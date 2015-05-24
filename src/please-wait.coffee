((root, factory) ->
  if typeof exports is "object"
    # CommonJS
    factory exports
  else if typeof define is "function" and define.amd
    # AMD. Register as an anonymous module.
    define ["exports"], factory
  else
    # Browser globals
    factory root
  return
) this, (exports) ->
  elm = document.createElement('fakeelement')
  animationSupport = false
  transitionSupport = false
  animationEvent = 'animationend'
  transitionEvent = null
  domPrefixes = 'Webkit Moz O ms'.split(' ')
  transEndEventNames =
    'WebkitTransition' : 'webkitTransitionEnd'
    'MozTransition' : 'transitionend'
    'OTransition' : 'oTransitionEnd'
    'msTransition' : 'MSTransitionEnd'
    'transition' : 'transitionend'

  for key, val of transEndEventNames
    if elm.style[key]?
      transitionEvent = val
      transitionSupport = true
      break

  if elm.style.animationName? then animationSupport = true

  if !animationSupport
    for pfx in domPrefixes
      if elm.style["#{pfx}AnimationName"]?
        switch pfx
          when 'Webkit'
            animationEvent = 'webkitAnimationEnd'
          when 'Moz'
            animationEvent = 'animationend'
          when 'O'
            animationEvent = 'oanimationend'
          when 'ms'
            animationEvent = 'MSAnimationEnd'
        animationSupport = true
        break

  # Helpers to add/remove classes, since we don't have our friend jQuery
  addClass = (classname, elem) ->
    if elem.classList
      elem.classList.add(classname)
    else
      elem.className += " #{classname}"

  removeClass = (classname, elem) ->
    if elem.classList
      elem.classList.remove(classname)
    else
      elem.className = elem.className.replace(classname, "").trim()

  class PleaseWait
    @_defaultOptions:
      backgroundColor: null
      logo: null
      loadingHtml: null
      template: """
        <div class='pg-loading-inner'>
          <div class='pg-loading-center-outer'>
            <div class='pg-loading-center-middle'>
              <h1 class='pg-loading-logo-header'>
                <img class='pg-loading-logo'></img>
              </h1>
              <div class='pg-loading-html'>
              </div>
            </div>
          </div>
        </div>
      """
      onLoadedCallback: null

    constructor: (options) ->
      defaultOptions = @constructor._defaultOptions
      @options = {}
      @loaded = false
      @finishing = false

      # Set initial options, merging given options with the defaults
      for k, v of defaultOptions
        @options[k] = if options[k]? then options[k] else v

      # Create the loading screen element
      @_loadingElem = document.createElement("div")
      # Create an empty array to store the potential list of loading HTML (messages, spinners, etc)
      # we'll be displaying to the screen
      @_loadingHtmlToDisplay = []
      # Add a global class for easy styling
      @_loadingElem.className = "pg-loading-screen"
      # Set the background color of the loading screen, if supplied
      @_loadingElem.style.backgroundColor = @options.backgroundColor if @options.backgroundColor?
      # Initialize the loading screen's HTML with the defined template. The default can be overwritten via options
      @_loadingElem.innerHTML = @options.template
      # Find the element that will contain the loading HTML displayed to the user (typically a spinner/message)
      # This can be changed via updateLoadingHtml
      @_loadingHtmlElem = @_loadingElem.getElementsByClassName("pg-loading-html")[0]
      # Set the initial loading HTML, if supplied
      @_loadingHtmlElem.innerHTML = @options.loadingHtml if @_loadingHtmlElem?
      # Set a flag that lets us know if the transitioning between loading HTML elements is finished.
      # If true, we can transition immediately to a new message/HTML
      @_readyToShowLoadingHtml = false
      # Find the element that displays the loading logo and set the src if supplied
      @_logoElem = @_loadingElem.getElementsByClassName("pg-loading-logo")[0]
      @_logoElem.src = @options.logo if @_logoElem?
      # Add the loading screen to the body
      removeClass("pg-loaded", document.body)
      addClass("pg-loading", document.body)
      document.body.appendChild(@_loadingElem)
      # Add the CSS class that will trigger the initial transitions of the logo/loading HTML
      addClass("pg-loading", @_loadingElem)
      # Register a callback to invoke when the loading screen is finished
      @_onLoadedCallback = @options.onLoadedCallback

      # Define a listener to look for any new loading HTML that needs to be displayed after the intiial transition finishes
      listener = (evt) =>
        @loaded = true
        @_readyToShowLoadingHtml = true
        addClass("pg-loaded", @_loadingHtmlElem)
        if animationSupport then @_loadingHtmlElem.removeEventListener(animationEvent, listener)
        if @_loadingHtmlToDisplay.length > 0 then @_changeLoadingHtml()
        if @finishing
          # If we reach here, it means @finish() was called while we were animating in, so we should
          # call @_finish() immediately. This registers a new event listener, which will fire
          # immediately, instead of waiting for the *next* animation to end. We stop propagation now
          # to prevent this conflict
          evt?.stopPropagation()
          @_finish()

      if @_loadingHtmlElem?
        # Detect CSS animation support. If not found, we'll call the listener immediately. Otherwise, we'll wait
        if animationSupport
          @_loadingHtmlElem.addEventListener(animationEvent, listener)
        else
          listener()

        # Define listeners for the transtioning out and in of new loading HTML/messages
        @_loadingHtmlListener = =>
          # New loading HTML has fully transitioned in. We're now ready to show a new message/HTML
          @_readyToShowLoadingHtml = true
          # Remove the CSS class that triggered the fade in animation
          removeClass("pg-loading", @_loadingHtmlElem)
          if transitionSupport then @_loadingHtmlElem.removeEventListener(transitionEvent, @_loadingHtmlListener)
          # Check if there's still HTML left in the queue to display. If so, let's show it
          if @_loadingHtmlToDisplay.length > 0 then @_changeLoadingHtml()

        @_removingHtmlListener = =>
          # Last loading HTML to display has fully transitioned out. Time to transition the new in
          @_loadingHtmlElem.innerHTML = @_loadingHtmlToDisplay.shift()
          # Add the CSS class to trigger the fade in animation
          removeClass("pg-removing", @_loadingHtmlElem)
          addClass("pg-loading", @_loadingHtmlElem)
          if transitionSupport
            @_loadingHtmlElem.removeEventListener(transitionEvent, @_removingHtmlListener)
            @_loadingHtmlElem.addEventListener(transitionEvent, @_loadingHtmlListener)
          else
            @_loadingHtmlListener()

    finish: (immediately = false, onLoadedCallback) ->
      # Our nice CSS animations won't run until the window is visible. This is a problem when the
      # site is loading in a background tab, since the loading screen won't animate out until the
      # window regains focus, which makes it look like the site takes forever to load! On browsers
      # that support it (IE10+), use the visibility API to immediately hide the loading screen if
      # the window is hidden
      if window.document.hidden then immediately = true

      # NOTE: if @loaded is false, the screen is still initializing. In that case, set @finishing to
      # true and let the existing listener handle calling @_finish for us. Otherwise, we can call
      # @_finish now to start the dismiss animation
      @finishing = true
      if onLoadedCallback? then @updateOption('onLoadedCallback', onLoadedCallback)
      if @loaded || immediately
        # Screen has fully initialized, so we are ready to close
        @_finish(immediately)

    updateOption: (option, value) ->
      switch option
        when 'backgroundColor'
          @_loadingElem.style.backgroundColor = value
        when 'logo'
          @_logoElem.src = value
        when 'loadingHtml'
          @updateLoadingHtml(value)
        when 'onLoadedCallback'
          @_onLoadedCallback = value
        else
          throw new Error("Unknown option '#{option}'")

    updateOptions: (options={}) ->
      for k, v of options
        @updateOption(k, v)

    updateLoadingHtml: (loadingHtml, immediately=false) ->
      unless @_loadingHtmlElem? then throw new Error("The loading template does not have an element of class 'pg-loading-html'")
      if immediately
        # Ignore any loading HTML that may be queued up. Show this immediately
        @_loadingHtmlToDisplay = [loadingHtml]
        @_readyToShowLoadingHtml = true
      else
        # Add to an array of HTML to display to the user
        @_loadingHtmlToDisplay.push(loadingHtml)
      # If ready, let's display the new loading HTML
      if @_readyToShowLoadingHtml then @_changeLoadingHtml()

    # Private method to immediately change the loading HTML displayed
    _changeLoadingHtml: ->
      @_readyToShowLoadingHtml = false
      # Remove any old event listeners that may still be attached to the DOM
      @_loadingHtmlElem.removeEventListener(transitionEvent, @_loadingHtmlListener)
      @_loadingHtmlElem.removeEventListener(transitionEvent, @_removingHtmlListener)
      # Remove any old CSS transition classes that may still be on the element
      removeClass("pg-loading", @_loadingHtmlElem)
      removeClass("pg-removing", @_loadingHtmlElem)

      if transitionSupport
        # Add the CSS class that will cause the HTML to fade out
        addClass("pg-removing", @_loadingHtmlElem)
        @_loadingHtmlElem.addEventListener(transitionEvent, @_removingHtmlListener)
      else
        @_removingHtmlListener()

    _finish: (immediately = false) ->
      return unless @_loadingElem?
      # Add a class to the body to signal that the loading screen has finished and the app is ready.
      # We do this here so that the user can display their HTML behind PleaseWait before it is
      # fully transitioned out. Otherwise, the HTML flashes oddly, since there's a brief moment
      # of time where there is no loading screen and no HTML
      addClass("pg-loaded", document.body)
      if typeof @_onLoadedCallback == "function" then @_onLoadedCallback.apply(this)

      # Again, define a listener to run once the loading screen has fully transitioned out
      listener = =>
        # Remove the loading screen from the body
        document.body.removeChild(@_loadingElem)
        # Remove the pg-loading class since we're done here
        removeClass("pg-loading", document.body)
        if animationSupport then @_loadingElem.removeEventListener(animationEvent, listener)
        # Reset the loading screen element since it's no longer attached to the DOM
        @_loadingElem = null

      # Detect CSS animation support. If not found, we'll call the listener immediately. Otherwise, we'll wait
      if !immediately && animationSupport
        # Set a class on the loading screen to trigger a fadeout animation
        addClass("pg-loaded", @_loadingElem)
        # When the loading screen is finished fading out, we'll remove it from the DOM
        @_loadingElem.addEventListener(animationEvent, listener)
      else
        listener()

  pleaseWait = (options = {}) ->
    new PleaseWait(options)

  exports.pleaseWait = pleaseWait
  return pleaseWait

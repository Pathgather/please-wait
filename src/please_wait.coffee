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
  PleaseWait = ->
    getTransitionEvent = ->
      el = document.createElement('fakeelement')
      transitions = {
        'transition':'transitionend',
        'OTransition':'oTransitionEnd',
        'msTransition': 'MSTransitionEnd',
        'MozTransition':'transitionend',
        'WebkitTransition':'webkitTransitionEnd'
      }

      for key, val of transitions
        return val if el.style[key]?

    _pleaseWait = {
      defaultOptions: {
        fadeOut: true,
        backgroundColor: '#f46d3b',
        logo: null,
        template: """
          <div class='pg-loading-inner'>
            <div class='pg-loading-center-outer'>
              <div class='pg-loading-center-middle'>
                <h1 class='pg-loading-logo-header'>
                  <img class='pg-loading-logo'></img>
                </h1>
                <div class='pg-loading-spinner'>
                </div>
              </div>
            </div>
          </div>
        """
      }

      done: ->
        return if @_done || !@_loadingDiv?
        @_done = true

        if @_options.fadeOut
          transitionEvent = getTransitionEvent()
          if transitionEvent?
            @_loadingDiv.className  += " pg-loaded"
            @_loadingDiv.addEventListener transitionEvent, () =>
              @_loadingDone()
          else
            @_loadingDone()
        else @_loadingDone()

      load: (options = {}) ->
        @_options                          = @_setOptions(options)
        @_loadingDiv                       = document.createElement("header")
        @_loadingDiv.className             = "pg-loading-screen"
        @_loadingDiv.style.backgroundColor = @_options.backgroundColor
        @_loadingDiv.innerHTML             = @_options.template
        spinnerTemplate                    = null
        spinner                            = @_loadingDiv.getElementsByClassName("pg-loading-spinner")[0]
        logo                               = @_loadingDiv.getElementsByClassName("pg-loading-logo")[0]
        logo.src                           = @_options.logo

        for script in document.scripts
          if script.id == "pgLoadingSpinner"
            spinnerTemplate = script.innerHTML
            break

        for stylesheet in document.styleSheets
          if stylesheet.ownerNode.id == "pgLoadingStylesheet"
            @_stylesheet = stylesheet
            break

        spinner.innerHTML = if spinnerTemplate?
          spinnerTemplate
        else if @_options.spinnerTemplate?
          @_options.spinnerTemplate
        else
          throw new Error("You need to set a spinner template ID or spinnerTemplate")

        document.body.appendChild(@_loadingDiv)

      _loadingDone: ->
        document.body.removeChild(@_loadingDiv)
        @_stylesheet.disabled = true
        document.body.className += " pg-loaded"

      _setOptions: (new_opts = {}) ->
        options = @defaultOptions

        # Set options
        for k, v of new_opts
          if options.hasOwnProperty(k) then options[k] = v

        options
    }

    return {
      start  : (options = {}) -> _pleaseWait.load(options)
      finish : -> _pleaseWait.done()
      status : (msg) -> _pleaseWait.status(msg)
    }

  exports.pleaseWait = new PleaseWait()
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
      transitions =
        'WebkitAnimation': 'webkitAnimationEnd',
        'OAnimation': 'oAnimationEnd',
        'msAnimation': 'MSAnimationEnd',
        'MozAnimation': 'mozAnimationEnd'
        'animation' : 'animationend'

      for key, val of transitions
        return val if el.style[key]?

    transitionEvent = getTransitionEvent()

    _pleaseWait =
      defaultOptions:
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

      done: ->
        return unless @_loadingDiv?
        listener = =>
          document.body.removeChild(@_loadingDiv)
          document.body.className += " pg-loaded"
          if transitionEvent? then @_loadingDiv.removeEventListener(transitionEvent, listener)
          @_loadingDiv = null

        if transitionEvent?
          @_loadingDiv.className  += " pg-loaded"
          @_loadingDiv.addEventListener(transitionEvent, listener)
        else
          listener()

      updateLoadingHtml: (loadingHtml) ->
        @_loadingHtmlToDisplay.push(options.loadingHtml)
        if @_readyToShowLoadingHtml then @_changeLoadingHtml()

      load: (options = {}) ->
        options                            = @_createOptions(options)
        @_loadingDiv                       ||= document.createElement("header")
        @_loadingHtmlToDisplay             = []
        @_loadingDiv.className             = "pg-loading-screen"
        @_loadingDiv.style.backgroundColor = options.backgroundColor if options.backgroundColor?
        @_loadingDiv.innerHTML             = options.template
        @_loadingHtml                      = @_loadingDiv.getElementsByClassName("pg-loading-html")[0]
        @_loadingHtml.innerHTML            = options.loadingHtml if @_loadingHtml?
        @_readyToShowLoadingHtml           = false
        logo                               = @_loadingDiv.getElementsByClassName("pg-loading-logo")[0]
        logo.src                           = options.logo if logo?

        document.body.appendChild(@_loadingDiv)
        @_loadingDiv.className += " pg-loading"

        listener = =>
          @_readyToShowLoadingHtml = true
          if transitionEvent? then @_loadingDiv.removeEventListener(transitionEvent, listener)
          if @_loadingHtmlToDisplay.length > 0 then @_changeLoadingHtml()

        if transitionEvent?
          @_loadingDiv.addEventListener(transitionEvent, listener)
        else
          listener()

        return @_loadingDiv

      _createOptions: (options = {}) ->
        defaultOptions = @defaultOptions
        newOptions     = {}

        # Set options
        for k, v of defaultOptions
          newOptions[k] = if options[k]? then options[k] else v

        newOptions

      _changeLoadingHtml: ->
        @_readyToShowLoadingHtml = false

        loadingListener  = =>
          @_readyToShowLoadingHtml = true
          @_loadingHtml.className = @_loadingHtml.className.replace(" pg-loading ", "")
          if transitionEvent? then @_loadingHtml.removeEventListener(transitionEvent, loadingListener)
          if @_loadingHtmlToDisplay.length > 0 then @_changeLoadingHtml()

        removingListener = =>
          @_loadingHtml.innerHTML = @_loadingHtmlToDisplay.shift()
          @_loadingHtml.className = @_loadingHtml.className.replace(" pg-removing ", " pg-loading ")
          if transitionEvent?
            @_loadingHtml.removeEventListener(transitionEvent, removingListener)
            @_loadingHtml.addEventListener(transitionEvent, loadingListener)
          else
            loadingListener()

        if transitionEvent?
          @_loadingHtml.className += " pg-removing "
          @_loadingHtml.addEventListener(transitionEvent, removingListener)
        else
          removingListener()

    return {
      start  : (options = {}) -> _pleaseWait.load(options)
      finish : -> _pleaseWait.done()
      updateLoadingHtml: (html) -> _pleaseWait.updateLoadingHtml(html)
    }

  exports.pleaseWait = new PleaseWait()
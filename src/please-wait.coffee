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

    _pleaseWait =
      defaultOptions:
        backgroundColor: null
        message: null
        showEllipsis: true
        logo: null
        spinnerTemplate: null
        template: """
          <div class='pg-loading-inner'>
            <div class='pg-loading-center-outer'>
              <div class='pg-loading-center-middle'>
                <h1 class='pg-loading-logo-header'>
                  <img class='pg-loading-logo'></img>
                </h1>
                <p class='pg-loading-message'>
                </p>
                <div class='pg-loading-spinner'>
                </div>
              </div>
            </div>
          </div>
        """

      done: ->
        return unless @_loadingDiv?
        transitionEvent = getTransitionEvent()
        listener        = =>
          document.body.removeChild(@_loadingDiv)
          document.body.className += " pg-loaded"
          if transitionEvent? then @_loadingDiv.removeEventListener(transitionEvent, listener)
          @_loadingDiv = null

        if transitionEvent?
          @_loadingDiv.className  += " pg-loaded"
          @_loadingDiv.addEventListener(transitionEvent, listener)
        else
          listener()

      load: (options = {}) ->
        @_options                          = @_createOptions(options)
        @_loadingDiv                       = document.createElement("header")
        @_loadingDiv.className             = "pg-loading-screen"
        @_loadingDiv.style.backgroundColor = @_options.backgroundColor if @_options.backgroundColor?
        @_loadingDiv.innerHTML             = @_options.template
        spinnerDiv                         = @_loadingDiv.getElementsByClassName("pg-loading-spinner")[0]
        logo                               = @_loadingDiv.getElementsByClassName("pg-loading-logo")[0]
        messageDiv                         = @_loadingDiv.getElementsByClassName("pg-loading-message")[0]

        if logo?
          logo.src = @_options.logo

        if spinnerDiv?
          if @_options.spinnerTemplate?
            spinnerDiv.innerHTML = @_options.spinnerTemplate
          else
            spinnerDiv.style.display = 'none'

        if messageDiv?
          if @_options.message?
            messageDiv.innerHTML = if @_options.showEllipsis
              """
                #{@_options.message}
                <span class='ellipsis one'>.</span>
                <span class='ellipsis two'>.</span>
                <span class='ellipsis three'>.</span>
              """
            else
              @_options.message
          else
            messageDiv.style.display = 'none'

        document.body.appendChild(@_loadingDiv)
        @_loadingDiv.className += " pg-loading"
        return @_loadingDiv

      _createOptions: (options = {}) ->
        defaultOptions = @defaultOptions
        newOptions     = {}

        # Set options
        for k, v of defaultOptions
          newOptions[k] = if options[k]? then options[k] else v

        newOptions

    return {
      start  : (options = {}) -> _pleaseWait.load(options)
      finish : -> _pleaseWait.done()
    }

  exports.pleaseWait = new PleaseWait()
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
        'WebkitAnimation': 'webkitAnimationEnd',
        'OAnimation': 'oAnimationEnd',
        'msAnimation': 'MSAnimationEnd',
        'MozAnimation': 'mozAnimationEnd'
        'animation' : 'animationend'
      }

      for key, val of transitions
        return val if el.style[key]?

    _pleaseWait = {
      defaultOptions: {
        backgroundColor: '#f46d3b',
        logo: null,
        spinnerTemplate: null,
        template: """
          <h1 class='pg-loading-logo-header'>
            <img class='pg-loading-logo'></img>
          </h1>
          <div class='pg-loading-spinner'>
          </div>
        """
      }

      done: ->
        return if @_done || !@_loadingDiv?
        @_done = true

        transitionEvent = getTransitionEvent()
        if transitionEvent?
          @_loadingDiv.className  += " pg-loaded"
          @_loadingDiv.addEventListener transitionEvent, () =>
            @_loadingDone()
        else
          @_loadingDone()

      load: (options = {}) ->
        @_options                          = @_setOptions(options)
        @_loadingDiv                       = document.createElement("header")
        @_loadingDiv.className             = "pg-loading-screen"
        @_loadingDiv.style.backgroundColor = @_options.backgroundColor
        @_loadingDiv.innerHTML             = @_options.template
        spinnerTemplate                    = null
        spinner                            = @_loadingDiv.getElementsByClassName("pg-loading-spinner")[0]
        spinner.innerHTML                  = @_options.spinnerTemplate
        logo                               = @_loadingDiv.getElementsByClassName("pg-loading-logo")[0]
        logo.src                           = @_options.logo

        for stylesheet in document.styleSheets
          if stylesheet.ownerNode.id == "pgLoadingStylesheet"
            @_stylesheet = stylesheet
            break

        document.body.appendChild(@_loadingDiv)
        @_loadingDiv.className += " pg-loading"

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
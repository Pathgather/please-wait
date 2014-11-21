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
        backgroundColor:
          default: '#f46d3b'
        logo:
          required: (options = {}) -> !options.template?
        spinnerTemplate:
          required: (options = {}) -> !options.template?
        template:
          default: """
            <h1 class='pg-loading-logo-header'>
              <img class='pg-loading-logo'></img>
            </h1>
            <div class='pg-loading-spinner'>
            </div>
          """

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
        @_options                          = @_createOptions(options)
        @_loadingDiv                       = document.createElement("header")
        @_loadingDiv.className             = "pg-loading-screen"
        @_loadingDiv.style.backgroundColor = @_options.backgroundColor
        @_loadingDiv.innerHTML             = @_options.template
        unless options.template?  # Initialize the default template with the logo and spinner
          spinnerTemplate                  = null
          spinner                          = @_loadingDiv.getElementsByClassName("pg-loading-spinner")[0]
          spinner.innerHTML                = @_options.spinnerTemplate
          logo                             = @_loadingDiv.getElementsByClassName("pg-loading-logo")[0]
          logo.src                         = @_options.logo

        document.body.appendChild(@_loadingDiv)
        @_loadingDiv.className += " pg-loading"

      _loadingDone: ->
        document.body.removeChild(@_loadingDiv)
        document.body.className += " pg-loaded"

      _createOptions: (options = {}) ->
        defaultOptions = @defaultOptions
        newOptions     = {}

        # Set options
        for k, v of defaultOptions
          optionSpecified = options[k]?
          if v.required?
            required = if typeof v.required == "function" then v.required(options) else v.required
            if required && !optionSpecified then throw new Error("Option '#{k}' is required")
          newOptions[k] = if optionSpecified then options[k] else v.default

        newOptions

    return {
      start  : (options = {}) -> _pleaseWait.load(options)
      finish : -> _pleaseWait.done()
    }

  exports.pleaseWait = new PleaseWait()
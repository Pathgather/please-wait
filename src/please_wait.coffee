do ->
  "use strict"

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

      status: (msg) ->
        @_messageDiv.innerHTML = msg

      load: (options = {}) ->
        @_options                          = options
        @_options.fadeOut                  = true unless options.fadeOut?
        @_loadingDiv                       = document.createElement("div")
        @_loadingDiv.className             = "pg-loading-screen"
        @_loadingDiv.style.backgroundColor = options.backgroundColor || "#f46d3b"
        @_messageDiv                       = document.createElement("div")
        @_messageDiv.className             = "pg-loading-message"
        spinner                            = document.createElement("div")
        spinner.className                  = "pg-loading-spinner"
        spinnerTemplate                    = null
        loadingInnerDiv                    = document.createElement("div")
        loadingInnerDiv.className          = "pg-loading-inner"
        loadingCenterOuterDiv              = document.createElement("div")
        loadingCenterOuterDiv.className    = "pg-loading-center-outer"
        loadingCenterMiddleDiv             = document.createElement("div")
        loadingCenterMiddleDiv.className   = "pg-loading-center-middle"
        logoImg                            = document.createElement("img")
        logoImg.className                  = "pg-loading-logo"
        logoImg.src                        = options.logo

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
        else if options.spinnerTemplate?
          options.spinnerTemplate
        else
          throw new Error("You need to set a spinner template ID or spinnerTemplate")

        loadingCenterMiddleDiv.appendChild(logoImg)
        loadingCenterMiddleDiv.appendChild(spinner)
        loadingCenterMiddleDiv.appendChild(@_messageDiv)
        loadingCenterOuterDiv.appendChild(loadingCenterMiddleDiv)
        loadingInnerDiv.appendChild(loadingCenterOuterDiv)
        @_loadingDiv.appendChild(loadingInnerDiv)
        document.body.appendChild(@_loadingDiv)

      _loadingDone: ->
        document.body.removeChild(@_loadingDiv)
        @_stylesheet.disabled = true
        document.body.className += " pg-loaded"
    }

    return {
      start  : (options = {}) -> _pleaseWait.load(options)
      finish : -> _pleaseWait.done()
      status : (msg) -> _pleaseWait.status(msg)
    }

  window.pleaseWait = new PleaseWait()
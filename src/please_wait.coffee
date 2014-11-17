do ->
  "use strict"

  PleaseWait = ->
    return {
      done: ->
        return if @_done || !@_loadingDiv?
        @_done = true

        if @_options.fadeOut
          transitionEvent = @_whichTransitionEvent()
          if transitionEvent?
            @_loadingDiv.className  += " pg-loaded"
            @_loadingDiv.addEventListener transitionEvent, () =>
              @_loadingDone()
          else
            @_loadingDone()
        else @_loadingDone()

      # status: (msg) ->
        # Want to show a status message, like "Checking for authentication", etc

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

        @_loadingDiv.innerHTML = """
          <div class='pg-loading-inner'>
            <div class='pg-loading-center-outer'>
              <div class='pg-loading-center-middle'>
                <img class='pg-loading-logo' src='#{options.logo}'></img>
                #{spinner.outerHTML}
              </div>
            </div>
          </div>
        """
        document.body.appendChild(@_loadingDiv)

      _whichTransitionEvent: ->
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

      _loadingDone: ->
        document.body.removeChild(@_loadingDiv)
        @_stylesheet.disabled = true
        document.body.className += " pg-loaded"
    }

  window.pleaseWait = new PleaseWait()
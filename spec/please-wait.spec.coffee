'use strict';

describe 'PleaseWait', ->
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

  it "defines pleaseWait", ->
    expect(window.pleaseWait).toBeDefined()

  describe 'a new pleaseWait loading screen', ->
    originalHTML = null
    beforeEach () ->
      if !originalHTML? then originalHTML = document.body.innerHTML

    afterEach () ->
      # Reset the body to its original state before each run. We could call finish, but we'll test that below
      document.body.innerHTML = originalHTML

    describe "when using the default template", ->
      describe "when setting a logo", ->
        it "sets the logo", ->
          window.pleaseWait({logo: "logo.png"})
          addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
          logo = addedScreen.getElementsByClassName("pg-loading-logo")[0]
          expect(logo.src).toContain("logo.png")

      describe "when setting loading HTML", ->
        it "adds the loading HTML", ->
          window.pleaseWait({loadingHtml: "<div>Spin!</div>"})
          addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
          loadingHtml = addedScreen.getElementsByClassName("pg-loading-html")[0]
          expect(loadingHtml.innerHTML).toEqual("<div>Spin!</div>")

    describe "when using a custom template", ->
      it "adds the template to the body", ->
        window.pleaseWait({template: "<div>LOADING!</div>"})
        addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
        expect(addedScreen.innerHTML).toEqual("<div>LOADING!</div>")

      describe "when the template has an img tag of class pg-loading-logo", ->
        it "sets the logo", ->
          window.pleaseWait({logo: "logo.png", template: "<div><img class='pg-loading-logo'></img></div>"})
          addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
          logo = addedScreen.getElementsByClassName("pg-loading-logo")[0]
          expect(logo.src).toContain("logo.png")

      describe "when the template has an element of class pg-loading-html", ->
        it "adds the loading HTML", ->
          window.pleaseWait({loadingHtml: "<div>Spin!</div>", template: "<div><div class='pg-loading-html'></div></div>"})
          addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
          loadingHtml = addedScreen.getElementsByClassName("pg-loading-html")[0]
          expect(loadingHtml.innerHTML).toEqual("<div>Spin!</div>")

    describe "when specifying a background color", ->
      it "sets the loading screen's background color", ->
        window.pleaseWait({logo: 'logo.png', loadingHtml: "<div></div>", backgroundColor: "#CCCCCC"})
        addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
        expect(addedScreen.style.backgroundColor).toEqual("rgb(204, 204, 204)")

    it "removes any existing pg-loaded classes from the body", ->
      document.body.className = "pg-loaded"
      window.pleaseWait()
      expect(document.body.className).toEqual("pg-loading")

  describe 'finish', ->
    loadingScreen = addedScreen = loadingHtml = onLoaded = null
    beforeEach ->
      onLoaded = jasmine.createSpy('onLoaded')
      loadingScreen = window.pleaseWait({logo: 'logo.png', loadingHtml: "<div></div>", onLoadedCallback: onLoaded})
      addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
      loadingHtml = document.body.getElementsByClassName("pg-loading-html")[0]
      expect(addedScreen).toBeDefined()

    describe "when the loading screen has finished animating in", ->
      beforeEach ->
        event = document.createEvent('Event')
        event.initEvent(getTransitionEvent(), true, true)
        loadingHtml.dispatchEvent event
        expect(onLoaded).not.toHaveBeenCalled()

      it "removes the loading screen from the body after it transitions out", ->
        loadingScreen.finish()
        expect(onLoaded).toHaveBeenCalled()
        event = document.createEvent('Event')
        event.initEvent(getTransitionEvent(), true, true)
        addedScreen.dispatchEvent event
        addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
        expect(addedScreen).not.toBeDefined()

    describe "when the loading screen has not yet finished animating in", ->
      it "waits for the current animation to finish, then removes the loading screen from the body after it transitions out", ->
        loadingScreen.finish()

        # Make sure that animation events on the loading screen do not dismiss yet
        event = document.createEvent('Event')
        event.initEvent(getTransitionEvent(), true, true)
        addedScreen.dispatchEvent event
        addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
        expect(addedScreen).toBeDefined()

        # Finish loading in animation
        expect(onLoaded).not.toHaveBeenCalled()
        event = document.createEvent('Event')
        event.initEvent(getTransitionEvent(), true, true)
        loadingHtml.dispatchEvent event
        addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
        expect(addedScreen).toBeDefined()
        expect(onLoaded).toHaveBeenCalled()

        # Now, finish loading out animation and ensure the loading screen is dismissed
        event = document.createEvent('Event')
        event.initEvent(getTransitionEvent(), true, true)
        addedScreen.dispatchEvent event
        addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
        expect(addedScreen).not.toBeDefined()

  describe 'when reloading multiple times', ->
    it "adds and removes pg-loaded & pg-loading from the body accordingly", ->
      document.body.className = "my-class"
      first = window.pleaseWait()
      expect(document.body.className).toEqual("my-class pg-loading")
      first.finish(true)
      expect(document.body.className).toEqual("my-class pg-loaded")
      second = window.pleaseWait()
      expect(document.body.className).toEqual("my-class pg-loading")
      second.finish(true)
      expect(document.body.className).toEqual("my-class pg-loaded")

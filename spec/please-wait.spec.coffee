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

  it "defines start & finish", ->
    expect(pleaseWait.start).toBeDefined()
    expect(pleaseWait.finish).toBeDefined()

  describe 'start', ->
    originalHTML = null
    beforeEach () ->
      if !originalHTML? then originalHTML = document.body.innerHTML

    afterEach () ->
      # Reset the body to its original state before each run. We could call finish, but we'll test that below
      document.body.innerHTML = originalHTML

    describe "when using the default template", ->
      describe "when setting a logo", ->
        it "sets the logo", ->
          pleaseWait.start({logo: "logo.png"})
          addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
          logo = addedScreen.getElementsByClassName("pg-loading-logo")[0]
          expect(logo.src).toContain("logo.png")

      describe "when setting loading HTML", ->
        it "adds the loading HTML", ->
          pleaseWait.start({loadingHtml: "<div>Spin!</div>"})
          addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
          loadingHtml = addedScreen.getElementsByClassName("pg-loading-html")[0]
          expect(loadingHtml.innerHTML).toEqual("<div>Spin!</div>")

    describe "when using a custom template", ->
      it "adds the template to the body", ->
        loadingScreen = pleaseWait.start({template: "<div>LOADING!</div>"})
        addedScreen   = document.body.getElementsByClassName("pg-loading-screen")[0]
        expect(loadingScreen).toEqual(addedScreen)
        expect(loadingScreen.innerHTML).toEqual("<div>LOADING!</div>")

      describe "when the template has an img tag of class pg-loading-logo", ->
        it "sets the logo", ->
          pleaseWait.start({logo: "logo.png", template: "<div><img class='pg-loading-logo'></img></div>"})
          addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
          logo = addedScreen.getElementsByClassName("pg-loading-logo")[0]
          expect(logo.src).toContain("logo.png")

      describe "when the template has an element of class pg-loading-html", ->
        it "adds the loading HTML", ->
          pleaseWait.start({loadingHtml: "<div>Spin!</div>", template: "<div><div class='pg-loading-html'></div></div>"})
          addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
          loadingHtml = addedScreen.getElementsByClassName("pg-loading-html")[0]
          expect(loadingHtml.innerHTML).toEqual("<div>Spin!</div>")

    describe "when specifying a background color", ->
      it "sets the loading screen's background color", ->
        loadingScreen = pleaseWait.start({logo: 'logo.png', loadingHtml: "<div></div>", backgroundColor: "#CCCCCC"})
        expect(loadingScreen.style.backgroundColor).toEqual("rgb(204, 204, 204)")

  describe 'finish', ->
    it "removes the loading screen from the body after it transitions out", ->
      addedScreen = pleaseWait.start({logo: 'logo.png', loadingHtml: "<div></div>"})
      addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
      expect(addedScreen).toBeDefined()
      pleaseWait.finish()
      event = document.createEvent('Event')
      event.initEvent(getTransitionEvent(), true, true)
      addedScreen.dispatchEvent event
      addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
      expect(addedScreen).not.toBeDefined()
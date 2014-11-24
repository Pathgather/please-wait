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
      it "requires a logo", ->
        expect(-> pleaseWait.start({logo: null, spinnerTemplate: "<div></div>"})).toThrowError("Option 'logo' is required")

      it "requires a spinner template", ->
        expect(-> pleaseWait.start({logo: 'logo.png', spinnerTemplate: null})).toThrowError("Option 'spinnerTemplate' is required")

      it "adds the template to the body", ->
        loadingScreen = pleaseWait.start({logo: 'logo.png', spinnerTemplate: "<div></div>"})
        addedScreen   = document.body.getElementsByClassName("pg-loading-screen")[0]
        expect(loadingScreen).toEqual(addedScreen)
        expect(addedScreen.nodeName).toEqual("HEADER")
        expect(loadingScreen.children[0].nodeName).toEqual("H1")

    describe "when using a custom template", ->
      it "does not require a logo", ->
        expect(-> pleaseWait.start({logo: null, template: "<div></div>"})).not.toThrow()

      it "does not require a spinner template", ->
        expect(-> pleaseWait.start({spinnerTemplate: null, template: "<div></div>"})).not.toThrow()

      it "adds the template to the body", ->
        loadingScreen = pleaseWait.start({logo: null, template: "<div></div>"})
        addedScreen   = document.body.getElementsByClassName("pg-loading-screen")[0]
        expect(loadingScreen).toEqual(addedScreen)
        expect(addedScreen.nodeName).toEqual("HEADER")
        expect(loadingScreen.children[0].nodeName).toEqual("DIV")

    describe "when specifying a background color", ->
      it "sets the loading screen's background color", ->
        loadingScreen = pleaseWait.start({logo: 'logo.png', spinnerTemplate: "<div></div>", backgroundColor: "#CCCCCC"})
        expect(loadingScreen.style.backgroundColor).toEqual("rgb(204, 204, 204)")

  describe 'finish', ->
    it "removes the loading screen from the body after it transitions out", ->
      addedScreen = pleaseWait.start({logo: 'logo.png', spinnerTemplate: "<div></div>"})
      addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
      expect(addedScreen).toBeDefined()
      pleaseWait.finish()
      event = document.createEvent('Event')
      event.initEvent(getTransitionEvent(), true, true)
      addedScreen.dispatchEvent event
      addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0]
      expect(addedScreen).not.toBeDefined()
'use strict';

describe 'PleaseWait', ->
  it "defines start & finish", ->
    expect(pleaseWait.start).toBeDefined()
    expect(pleaseWait.finish).toBeDefined()

  describe 'start', ->
    describe "when using the default template", ->
      it "requires a logo", ->
        expect(-> pleaseWait.start({logo: null, spinnerTemplate: "<div></div>"})).toThrowError("Option 'logo' is required")

      it "requires a spinner template", ->
        expect(-> pleaseWait.start({logo: 'logo.png', spinnerTemplate: null})).toThrowError("Option 'spinnerTemplate' is required")

    describe "when using a custom template", ->
      it "does not require a logo", ->
        expect(-> pleaseWait.start({logo: null, template: "<div></div>"})).not.toThrow()

      it "does not require a spinner template", ->
        expect(-> pleaseWait.start({spinnerTemplate: null, template: "<div></div>"})).not.toThrow()


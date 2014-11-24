/**

* Please Wait
* Display a nice loading screen while your app loads

* @author Pathgather <tech@pathgather.com>
* @copyright Pathgather 2014
* @license MIT <http://opensource.org/licenses/mit-license.php>
* @link https://github.com/Pathgather/please-wait
* @module pleaseWait
* @version 0.0.1
*/
(function(root, factory) {
  if (typeof exports === "object") {
    factory(exports);
  } else if (typeof define === "function" && define.amd) {
    define(["exports"], factory);
  } else {
    factory(root);
  }
})(this, function(exports) {
  var PleaseWait;
  PleaseWait = function() {
    var getTransitionEvent, _pleaseWait;
    getTransitionEvent = function() {
      var el, key, transitions, val;
      el = document.createElement('fakeelement');
      transitions = {
        'WebkitAnimation': 'webkitAnimationEnd',
        'OAnimation': 'oAnimationEnd',
        'msAnimation': 'MSAnimationEnd',
        'MozAnimation': 'mozAnimationEnd',
        'animation': 'animationend'
      };
      for (key in transitions) {
        val = transitions[key];
        if (el.style[key] != null) {
          return val;
        }
      }
    };
    _pleaseWait = {
      defaultOptions: {
        backgroundColor: {
          required: false
        },
        logo: {
          required: function(options) {
            if (options == null) {
              options = {};
            }
            return options.template == null;
          }
        },
        spinnerTemplate: {
          required: function(options) {
            if (options == null) {
              options = {};
            }
            return options.template == null;
          }
        },
        template: {
          "default": "<h1 class='pg-loading-logo-header'>\n  <img class='pg-loading-logo'></img>\n</h1>\n<div class='pg-loading-spinner'>\n</div>"
        }
      },
      done: function() {
        var listener, transitionEvent;
        if (this._loadingDiv == null) {
          return;
        }
        transitionEvent = getTransitionEvent();
        listener = (function(_this) {
          return function() {
            document.body.removeChild(_this._loadingDiv);
            document.body.className += " pg-loaded";
            if (transitionEvent != null) {
              _this._loadingDiv.removeEventListener(transitionEvent, listener);
            }
            return _this._loadingDiv = null;
          };
        })(this);
        if (transitionEvent != null) {
          this._loadingDiv.className += " pg-loaded";
          return this._loadingDiv.addEventListener(transitionEvent, listener);
        } else {
          return listener();
        }
      },
      load: function(options) {
        var logo, spinner, spinnerTemplate;
        if (options == null) {
          options = {};
        }
        this._options = this._createOptions(options);
        this._loadingDiv = document.createElement("header");
        this._loadingDiv.className = "pg-loading-screen";
        if (this._options.backgroundColor != null) {
          this._loadingDiv.style.backgroundColor = this._options.backgroundColor;
        }
        this._loadingDiv.innerHTML = this._options.template;
        if (options.template == null) {
          spinnerTemplate = null;
          spinner = this._loadingDiv.getElementsByClassName("pg-loading-spinner")[0];
          spinner.innerHTML = this._options.spinnerTemplate;
          logo = this._loadingDiv.getElementsByClassName("pg-loading-logo")[0];
          logo.src = this._options.logo;
        }
        document.body.appendChild(this._loadingDiv);
        this._loadingDiv.className += " pg-loading";
        return this._loadingDiv;
      },
      _createOptions: function(options) {
        var defaultOptions, k, newOptions, optionSpecified, required, v;
        if (options == null) {
          options = {};
        }
        defaultOptions = this.defaultOptions;
        newOptions = {};
        for (k in defaultOptions) {
          v = defaultOptions[k];
          optionSpecified = options[k] != null;
          if (v.required != null) {
            required = typeof v.required === "function" ? v.required(options) : v.required;
            if (required && !optionSpecified) {
              throw new Error("Option '" + k + "' is required");
            }
          }
          newOptions[k] = optionSpecified ? options[k] : v["default"];
        }
        return newOptions;
      }
    };
    return {
      start: function(options) {
        if (options == null) {
          options = {};
        }
        return _pleaseWait.load(options);
      },
      finish: function() {
        return _pleaseWait.done();
      }
    };
  };
  return exports.pleaseWait = new PleaseWait();
});

(function(root, factory) {
  if (typeof exports === "object") {
    factory(exports);
  } else if (typeof define === "function" && define.amd) {
    define(["exports"], factory);
  } else {
    factory(root);
  }
})(this, function(exports) {
  var PleaseWait;
  PleaseWait = function() {
    var getTransitionEvent, _pleaseWait;
    getTransitionEvent = function() {
      var el, key, transitions, val;
      el = document.createElement('fakeelement');
      transitions = {
        'WebkitAnimation': 'webkitAnimationEnd',
        'OAnimation': 'oAnimationEnd',
        'msAnimation': 'MSAnimationEnd',
        'MozAnimation': 'mozAnimationEnd',
        'animation': 'animationend'
      };
      for (key in transitions) {
        val = transitions[key];
        if (el.style[key] != null) {
          return val;
        }
      }
    };
    _pleaseWait = {
      defaultOptions: {
        backgroundColor: {
          required: false
        },
        logo: {
          required: function(options) {
            if (options == null) {
              options = {};
            }
            return options.template == null;
          }
        },
        spinnerTemplate: {
          required: function(options) {
            if (options == null) {
              options = {};
            }
            return options.template == null;
          }
        },
        template: {
          "default": "<h1 class='pg-loading-logo-header'>\n  <img class='pg-loading-logo'></img>\n</h1>\n<div class='pg-loading-spinner'>\n</div>"
        }
      },
      done: function() {
        var listener, transitionEvent;
        if (this._loadingDiv == null) {
          return;
        }
        transitionEvent = getTransitionEvent();
        listener = (function(_this) {
          return function() {
            document.body.removeChild(_this._loadingDiv);
            document.body.className += " pg-loaded";
            if (transitionEvent != null) {
              _this._loadingDiv.removeEventListener(transitionEvent, listener);
            }
            return _this._loadingDiv = null;
          };
        })(this);
        if (transitionEvent != null) {
          this._loadingDiv.className += " pg-loaded";
          return this._loadingDiv.addEventListener(transitionEvent, listener);
        } else {
          return listener();
        }
      },
      load: function(options) {
        var logo, spinner, spinnerTemplate;
        if (options == null) {
          options = {};
        }
        this._options = this._createOptions(options);
        this._loadingDiv = document.createElement("header");
        this._loadingDiv.className = "pg-loading-screen";
        if (this._options.backgroundColor != null) {
          this._loadingDiv.style.backgroundColor = this._options.backgroundColor;
        }
        this._loadingDiv.innerHTML = this._options.template;
        if (options.template == null) {
          spinnerTemplate = null;
          spinner = this._loadingDiv.getElementsByClassName("pg-loading-spinner")[0];
          spinner.innerHTML = this._options.spinnerTemplate;
          logo = this._loadingDiv.getElementsByClassName("pg-loading-logo")[0];
          logo.src = this._options.logo;
        }
        document.body.appendChild(this._loadingDiv);
        this._loadingDiv.className += " pg-loading";
        return this._loadingDiv;
      },
      _createOptions: function(options) {
        var defaultOptions, k, newOptions, optionSpecified, required, v;
        if (options == null) {
          options = {};
        }
        defaultOptions = this.defaultOptions;
        newOptions = {};
        for (k in defaultOptions) {
          v = defaultOptions[k];
          optionSpecified = options[k] != null;
          if (v.required != null) {
            required = typeof v.required === "function" ? v.required(options) : v.required;
            if (required && !optionSpecified) {
              throw new Error("Option '" + k + "' is required");
            }
          }
          newOptions[k] = optionSpecified ? options[k] : v["default"];
        }
        return newOptions;
      }
    };
    return {
      start: function(options) {
        if (options == null) {
          options = {};
        }
        return _pleaseWait.load(options);
      },
      finish: function() {
        return _pleaseWait.done();
      }
    };
  };
  return exports.pleaseWait = new PleaseWait();
});

(function() {
  'use strict';
  describe('PleaseWait', function() {
    var getTransitionEvent;
    getTransitionEvent = function() {
      var el, key, transitions, val;
      el = document.createElement('fakeelement');
      transitions = {
        'WebkitAnimation': 'webkitAnimationEnd',
        'OAnimation': 'oAnimationEnd',
        'msAnimation': 'MSAnimationEnd',
        'MozAnimation': 'mozAnimationEnd',
        'animation': 'animationend'
      };
      for (key in transitions) {
        val = transitions[key];
        if (el.style[key] != null) {
          return val;
        }
      }
    };
    it("defines start & finish", function() {
      expect(pleaseWait.start).toBeDefined();
      return expect(pleaseWait.finish).toBeDefined();
    });
    describe('start', function() {
      var originalHTML;
      originalHTML = null;
      beforeEach(function() {
        if (originalHTML == null) {
          return originalHTML = document.body.innerHTML;
        }
      });
      afterEach(function() {
        return document.body.innerHTML = originalHTML;
      });
      describe("when using the default template", function() {
        it("requires a logo", function() {
          return expect(function() {
            return pleaseWait.start({
              logo: null,
              spinnerTemplate: "<div></div>"
            });
          }).toThrowError("Option 'logo' is required");
        });
        it("requires a spinner template", function() {
          return expect(function() {
            return pleaseWait.start({
              logo: 'logo.png',
              spinnerTemplate: null
            });
          }).toThrowError("Option 'spinnerTemplate' is required");
        });
        return it("adds the template to the body", function() {
          var addedScreen, loadingScreen;
          loadingScreen = pleaseWait.start({
            logo: 'logo.png',
            spinnerTemplate: "<div></div>"
          });
          addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0];
          expect(loadingScreen).toEqual(addedScreen);
          expect(addedScreen.nodeName).toEqual("HEADER");
          return expect(loadingScreen.children[0].nodeName).toEqual("H1");
        });
      });
      describe("when using a custom template", function() {
        it("does not require a logo", function() {
          return expect(function() {
            return pleaseWait.start({
              logo: null,
              template: "<div></div>"
            });
          }).not.toThrow();
        });
        it("does not require a spinner template", function() {
          return expect(function() {
            return pleaseWait.start({
              spinnerTemplate: null,
              template: "<div></div>"
            });
          }).not.toThrow();
        });
        return it("adds the template to the body", function() {
          var addedScreen, loadingScreen;
          loadingScreen = pleaseWait.start({
            logo: null,
            template: "<div></div>"
          });
          addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0];
          expect(loadingScreen).toEqual(addedScreen);
          expect(addedScreen.nodeName).toEqual("HEADER");
          return expect(loadingScreen.children[0].nodeName).toEqual("DIV");
        });
      });
      return describe("when specifying a background color", function() {
        return it("sets the loading screen's background color", function() {
          var loadingScreen;
          loadingScreen = pleaseWait.start({
            logo: 'logo.png',
            spinnerTemplate: "<div></div>",
            backgroundColor: "#CCCCCC"
          });
          return expect(loadingScreen.style.backgroundColor).toEqual("rgb(204, 204, 204)");
        });
      });
    });
    return describe('finish', function() {
      return it("removes the loading screen from the body after it transitions out", function() {
        var addedScreen, event;
        addedScreen = pleaseWait.start({
          logo: 'logo.png',
          spinnerTemplate: "<div></div>"
        });
        addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0];
        expect(addedScreen).toBeDefined();
        pleaseWait.finish();
        event = document.createEvent('Event');
        event.initEvent(getTransitionEvent(), true, true);
        addedScreen.dispatchEvent(event);
        addedScreen = document.body.getElementsByClassName("pg-loading-screen")[0];
        return expect(addedScreen).not.toBeDefined();
      });
    });
  });

}).call(this);

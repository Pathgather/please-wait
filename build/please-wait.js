/* please-wait - v0.0.0 - 2014-11-21 */
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
        backgroundColor: '#f46d3b',
        logo: null,
        spinnerTemplate: null,
        template: "<h1 class='pg-loading-logo-header'>\n  <img class='pg-loading-logo'></img>\n</h1>\n<div class='pg-loading-spinner'>\n</div>"
      },
      done: function() {
        var transitionEvent;
        if (this._done || (this._loadingDiv == null)) {
          return;
        }
        this._done = true;
        transitionEvent = getTransitionEvent();
        if (transitionEvent != null) {
          this._loadingDiv.className += " pg-loaded";
          return this._loadingDiv.addEventListener(transitionEvent, (function(_this) {
            return function() {
              return _this._loadingDone();
            };
          })(this));
        } else {
          return this._loadingDone();
        }
      },
      load: function(options) {
        var logo, spinner, spinnerTemplate, stylesheet, _i, _len, _ref;
        if (options == null) {
          options = {};
        }
        this._options = this._setOptions(options);
        this._loadingDiv = document.createElement("header");
        this._loadingDiv.className = "pg-loading-screen";
        this._loadingDiv.style.backgroundColor = this._options.backgroundColor;
        this._loadingDiv.innerHTML = this._options.template;
        spinnerTemplate = null;
        spinner = this._loadingDiv.getElementsByClassName("pg-loading-spinner")[0];
        spinner.innerHTML = this._options.spinnerTemplate;
        logo = this._loadingDiv.getElementsByClassName("pg-loading-logo")[0];
        logo.src = this._options.logo;
        _ref = document.styleSheets;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          stylesheet = _ref[_i];
          if (stylesheet.ownerNode.id === "pgLoadingStylesheet") {
            this._stylesheet = stylesheet;
            break;
          }
        }
        document.body.appendChild(this._loadingDiv);
        return this._loadingDiv.className += " pg-loading";
      },
      _loadingDone: function() {
        document.body.removeChild(this._loadingDiv);
        this._stylesheet.disabled = true;
        return document.body.className += " pg-loaded";
      },
      _setOptions: function(new_opts) {
        var k, options, v;
        if (new_opts == null) {
          new_opts = {};
        }
        options = this.defaultOptions;
        for (k in new_opts) {
          v = new_opts[k];
          if (options.hasOwnProperty(k)) {
            options[k] = v;
          }
        }
        return options;
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
    return it('defines start & finish', function() {
      expect(pleaseWait.start).toBeDefined();
      return expect(pleaseWait.finish).toBeDefined();
    });
  });

}).call(this);

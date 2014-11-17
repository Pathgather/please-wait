/* please-wait - v0.0.0 - 2014-11-16 */
(function() {
  "use strict";
  var PleaseWait;
  PleaseWait = function() {
    return {
      done: function() {
        var transitionEvent;
        if (this._done || (this._loadingDiv == null)) {
          return;
        }
        this._done = true;
        if (this._options.fadeOut) {
          transitionEvent = this._whichTransitionEvent();
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
        } else {
          return this._loadingDone();
        }
      },
      load: function(options) {
        var script, spinner, spinnerTemplate, stylesheet, _i, _j, _len, _len1, _ref, _ref1;
        if (options == null) {
          options = {};
        }
        this._options = options;
        if (options.fadeOut == null) {
          this._options.fadeOut = true;
        }
        this._loadingDiv = document.createElement("div");
        this._loadingDiv.className = "pg-loading-screen";
        this._loadingDiv.style.backgroundColor = options.backgroundColor || "#f46d3b";
        this._messageDiv = document.createElement("div");
        this._messageDiv.className = "pg-loading-message";
        spinner = document.createElement("div");
        spinner.className = "pg-loading-spinner";
        spinnerTemplate = null;
        _ref = document.scripts;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          script = _ref[_i];
          if (script.id === "pgLoadingSpinner") {
            spinnerTemplate = script.innerHTML;
            break;
          }
        }
        _ref1 = document.styleSheets;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          stylesheet = _ref1[_j];
          if (stylesheet.ownerNode.id === "pgLoadingStylesheet") {
            this._stylesheet = stylesheet;
            break;
          }
        }
        spinner.innerHTML = (function() {
          if (spinnerTemplate != null) {
            return spinnerTemplate;
          } else if (options.spinnerTemplate != null) {
            return options.spinnerTemplate;
          } else {
            throw new Error("You need to set a spinner template ID or spinnerTemplate");
          }
        })();
        this._loadingDiv.innerHTML = "<div class='pg-loading-inner'>\n  <div class='pg-loading-center-outer'>\n    <div class='pg-loading-center-middle'>\n      <img class='pg-loading-logo' src='" + options.logo + "'></img>\n      " + spinner.outerHTML + "\n    </div>\n  </div>\n</div>";
        return document.body.appendChild(this._loadingDiv);
      },
      _whichTransitionEvent: function() {
        var el, key, transitions, val;
        el = document.createElement('fakeelement');
        transitions = {
          'transition': 'transitionend',
          'OTransition': 'oTransitionEnd',
          'msTransition': 'MSTransitionEnd',
          'MozTransition': 'transitionend',
          'WebkitTransition': 'webkitTransitionEnd'
        };
        for (key in transitions) {
          val = transitions[key];
          if (el.style[key] != null) {
            return val;
          }
        }
      },
      _loadingDone: function() {
        document.body.removeChild(this._loadingDiv);
        this._stylesheet.disabled = true;
        return document.body.className += " pg-loaded";
      }
    };
  };
  return window.pleaseWait = new PleaseWait();
})();

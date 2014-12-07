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
  var PleaseWait, getTransitionEvent, pleaseWait, transitionEvent;
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
  transitionEvent = getTransitionEvent();
  PleaseWait = (function() {
    PleaseWait._defaultOptions = {
      backgroundColor: null,
      logo: null,
      loadingHtml: null,
      template: "<div class='pg-loading-inner'>\n  <div class='pg-loading-center-outer'>\n    <div class='pg-loading-center-middle'>\n      <h1 class='pg-loading-logo-header'>\n        <img class='pg-loading-logo'></img>\n      </h1>\n      <div class='pg-loading-html'>\n      </div>\n    </div>\n  </div>\n</div>"
    };

    function PleaseWait(options) {
      var defaultOptions, k, listener, logoElem, v;
      defaultOptions = this.constructor._defaultOptions;
      this.options = {};
      for (k in defaultOptions) {
        v = defaultOptions[k];
        this.options[k] = options[k] != null ? options[k] : v;
      }
      this._loadingElem = document.createElement("div");
      this._loadingHtmlToDisplay = [];
      this._loadingElem.className = "pg-loading-screen";
      if (this.options.backgroundColor != null) {
        this._loadingElem.style.backgroundColor = this.options.backgroundColor;
      }
      this._loadingElem.innerHTML = this.options.template;
      this._loadingHtmlElem = this._loadingElem.getElementsByClassName("pg-loading-html")[0];
      if (this._loadingHtmlElem != null) {
        this._loadingHtmlElem.innerHTML = this.options.loadingHtml;
      }
      this._readyToShowLoadingHtml = false;
      logoElem = this._loadingElem.getElementsByClassName("pg-loading-logo")[0];
      if (logoElem != null) {
        logoElem.src = this.options.logo;
      }
      document.body.appendChild(this._loadingElem);
      this._loadingElem.className += " pg-loading";
      listener = (function(_this) {
        return function() {
          _this._readyToShowLoadingHtml = true;
          if (transitionEvent != null) {
            _this._loadingHtmlElem.removeEventListener(transitionEvent, listener);
          }
          if (_this._loadingHtmlToDisplay.length > 0) {
            return _this._changeLoadingHtml();
          }
        };
      })(this);
      if (this._loadingHtmlElem != null) {
        if (transitionEvent != null) {
          this._loadingHtmlElem.addEventListener(transitionEvent, listener);
        } else {
          listener();
        }
        this._loadingHtmlListener = (function(_this) {
          return function() {
            _this._readyToShowLoadingHtml = true;
            _this._loadingHtmlElem.className = _this._loadingHtmlElem.className.replace(" pg-loading ", "");
            if (transitionEvent != null) {
              _this._loadingHtmlElem.removeEventListener(transitionEvent, _this._loadingHtmlListener);
            }
            if (_this._loadingHtmlToDisplay.length > 0) {
              return _this._changeLoadingHtml();
            }
          };
        })(this);
        this._removingHtmlListener = (function(_this) {
          return function() {
            _this._loadingHtmlElem.innerHTML = _this._loadingHtmlToDisplay.shift();
            _this._loadingHtmlElem.className = _this._loadingHtmlElem.className.replace(" pg-removing ", " pg-loading ");
            if (transitionEvent != null) {
              _this._loadingHtmlElem.removeEventListener(transitionEvent, _this._removingHtmlListener);
              return _this._loadingHtmlElem.addEventListener(transitionEvent, _this._loadingHtmlListener);
            } else {
              return _this._loadingHtmlListener();
            }
          };
        })(this);
      }
    }

    PleaseWait.prototype.finish = function() {
      var listener;
      if (this._loadingElem == null) {
        return;
      }
      listener = (function(_this) {
        return function() {
          document.body.removeChild(_this._loadingElem);
          document.body.className += " pg-loaded";
          if (transitionEvent != null) {
            _this._loadingElem.removeEventListener(transitionEvent, listener);
          }
          return _this._loadingElem = null;
        };
      })(this);
      if (transitionEvent != null) {
        this._loadingElem.className += " pg-loaded";
        return this._loadingElem.addEventListener(transitionEvent, listener);
      } else {
        return listener();
      }
    };

    PleaseWait.prototype.updateLoadingHtml = function(loadingHtml, immediately) {
      if (immediately == null) {
        immediately = false;
      }
      if (this._loadingHtmlElem == null) {
        throw new Error("The loading template does not have an element of class 'pg-loading-html'");
      }
      if (immediately) {
        this._loadingHtmlToDisplay = [loadingHtml];
        this._readyToShowLoadingHtml = true;
      } else {
        this._loadingHtmlToDisplay.push(loadingHtml);
      }
      if (this._readyToShowLoadingHtml) {
        return this._changeLoadingHtml();
      }
    };

    PleaseWait.prototype._changeLoadingHtml = function() {
      this._readyToShowLoadingHtml = false;
      this._loadingHtmlElem.removeEventListener(transitionEvent, this._loadingHtmlListener);
      this._loadingHtmlElem.removeEventListener(transitionEvent, this._removingHtmlListener);
      this._loadingHtmlElem.className = this._loadingHtmlElem.className.replace(" pg-loading ", "").replace(" pg-removing ", "");
      if (transitionEvent != null) {
        this._loadingHtmlElem.className += " pg-removing ";
        return this._loadingHtmlElem.addEventListener(transitionEvent, this._removingHtmlListener);
      } else {
        return this._removingHtmlListener();
      }
    };

    return PleaseWait;

  })();
  pleaseWait = function(options) {
    if (options == null) {
      options = {};
    }
    return new PleaseWait(options);
  };
  exports.pleaseWait = pleaseWait;
  return pleaseWait;
});

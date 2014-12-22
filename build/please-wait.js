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
  var PleaseWait, animationEvent, animationSupport, domPrefixes, elm, key, pfx, pleaseWait, transEndEventNames, transitionEvent, transitionSupport, val, _i, _len;
  elm = document.createElement('fakeelement');
  animationSupport = false;
  transitionSupport = false;
  animationEvent = 'animationend';
  transitionEvent = null;
  domPrefixes = 'Webkit Moz O ms'.split(' ');
  transEndEventNames = {
    'WebkitTransition': 'webkitTransitionEnd',
    'MozTransition': 'transitionend',
    'OTransition': 'oTransitionEnd',
    'msTransition': 'MSTransitionEnd',
    'transition': 'transitionend'
  };
  for (key in transEndEventNames) {
    val = transEndEventNames[key];
    if (elm.style[key] != null) {
      transitionEvent = val;
      transitionSupport = true;
      break;
    }
  }
  if (elm.style.animationName != null) {
    animationSupport = true;
  }
  if (!animationSupport) {
    for (_i = 0, _len = domPrefixes.length; _i < _len; _i++) {
      pfx = domPrefixes[_i];
      if (elm.style["" + pfx + "AnimationName"] != null) {
        switch (pfx) {
          case 'Webkit':
            animationEvent = 'webkitAnimationEnd';
            break;
          case 'Moz':
            animationEvent = 'animationend';
            break;
          case 'O':
            animationEvent = 'oanimationend';
            break;
          case 'ms':
            animationEvent = 'MSAnimationEnd';
        }
        animationSupport = true;
        break;
      }
    }
  }
  PleaseWait = (function() {
    PleaseWait._defaultOptions = {
      backgroundColor: null,
      logo: null,
      loadingHtml: null,
      template: "<div class='pg-loading-inner'>\n  <div class='pg-loading-center-outer'>\n    <div class='pg-loading-center-middle'>\n      <h1 class='pg-loading-logo-header'>\n        <img class='pg-loading-logo'></img>\n      </h1>\n      <div class='pg-loading-html'>\n      </div>\n    </div>\n  </div>\n</div>"
    };

    function PleaseWait(options) {
      var defaultOptions, k, listener, v;
      defaultOptions = this.constructor._defaultOptions;
      this.options = {};
      this.loaded = false;
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
      this._logoElem = this._loadingElem.getElementsByClassName("pg-loading-logo")[0];
      if (this._logoElem != null) {
        this._logoElem.src = this.options.logo;
      }
      document.body.className += " pg-loading";
      document.body.appendChild(this._loadingElem);
      this._loadingElem.className += " pg-loading";
      listener = (function(_this) {
        return function() {
          _this.loaded = true;
          _this._readyToShowLoadingHtml = true;
          _this._loadingHtmlElem.className += " pg-loaded";
          if (animationSupport) {
            _this._loadingHtmlElem.removeEventListener(animationEvent, listener);
          }
          if (_this._loadingHtmlToDisplay.length > 0) {
            return _this._changeLoadingHtml();
          }
        };
      })(this);
      if (this._loadingHtmlElem != null) {
        if (animationSupport) {
          this._loadingHtmlElem.addEventListener(animationEvent, listener);
        } else {
          listener();
        }
        this._loadingHtmlListener = (function(_this) {
          return function() {
            _this._readyToShowLoadingHtml = true;
            _this._loadingHtmlElem.className = _this._loadingHtmlElem.className.replace(" pg-loading ", "");
            if (transitionSupport) {
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
            if (transitionSupport) {
              _this._loadingHtmlElem.removeEventListener(transitionEvent, _this._removingHtmlListener);
              return _this._loadingHtmlElem.addEventListener(transitionEvent, _this._loadingHtmlListener);
            } else {
              return _this._loadingHtmlListener();
            }
          };
        })(this);
      }
    }

    PleaseWait.prototype.finish = function(immediately) {
      var listener;
      if (immediately == null) {
        immediately = false;
      }
      if (this._loadingElem == null) {
        return;
      }
      if (this.loaded || immediately) {
        return this._finish();
      } else {
        listener = (function(_this) {
          return function() {
            _this._loadingElem.removeEventListener(animationEvent, listener);
            return window.setTimeout(function() {
              return _this._finish();
            }, 1);
          };
        })(this);
        return this._loadingHtmlElem.addEventListener(animationEvent, listener);
      }
    };

    PleaseWait.prototype.updateOption = function(option, value) {
      switch (option) {
        case 'backgroundColor':
          return this._loadingElem.style.backgroundColor = value;
        case 'logo':
          return this._logoElem.src = value;
        case 'loadingHtml':
          return this.updateLoadingHtml(value);
        default:
          throw new Error("Unknown option '" + option + "'");
      }
    };

    PleaseWait.prototype.updateOptions = function(options) {
      var k, v, _results;
      if (options == null) {
        options = {};
      }
      _results = [];
      for (k in options) {
        v = options[k];
        _results.push(this.updateOption(k, v));
      }
      return _results;
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
      if (transitionSupport) {
        this._loadingHtmlElem.className += " pg-removing ";
        return this._loadingHtmlElem.addEventListener(transitionEvent, this._removingHtmlListener);
      } else {
        return this._removingHtmlListener();
      }
    };

    PleaseWait.prototype._finish = function() {
      var listener;
      document.body.className += " pg-loaded";
      listener = (function(_this) {
        return function() {
          document.body.removeChild(_this._loadingElem);
          document.body.className = document.body.className.replace("pg-loading", "");
          if (animationSupport) {
            _this._loadingElem.removeEventListener(animationEvent, listener);
          }
          return _this._loadingElem = null;
        };
      })(this);
      if (animationSupport) {
        this._loadingElem.className += " pg-loaded";
        return this._loadingElem.addEventListener(animationEvent, listener);
      } else {
        return listener();
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

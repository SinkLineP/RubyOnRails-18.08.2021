/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/packs/";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./app/javascript/packs/responsiveslides.min.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/javascript/packs/responsiveslides.min.js":
/*!******************************************************!*\
  !*** ./app/javascript/packs/responsiveslides.min.js ***!
  \******************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

/* WEBPACK VAR INJECTION */(function(jQuery) {/*! http://responsiveslides.com v1.54 by @viljamis */
(function (c, I, B) {
  c.fn.responsiveSlides = function (l) {
    var a = c.extend({
      auto: !0,
      speed: 500,
      timeout: 4E3,
      pager: !1,
      nav: !1,
      random: !1,
      pause: !1,
      pauseControls: !0,
      prevText: "Previous",
      nextText: "Next",
      maxwidth: "",
      navContainer: "",
      manualControls: "",
      namespace: "rslides",
      before: c.noop,
      after: c.noop
    }, l);
    return this.each(function () {
      B++;

      var f = c(this),
          s,
          r,
          t,
          m,
          p,
          q,
          n = 0,
          e = f.children(),
          C = e.size(),
          h = parseFloat(a.speed),
          D = parseFloat(a.timeout),
          u = parseFloat(a.maxwidth),
          g = a.namespace,
          d = g + B,
          E = g + "_nav " + d + "_nav",
          v = g + "_here",
          j = d + "_on",
          w = d + "_s",
          k = c("<ul class='" + g + "_tabs " + d + "_tabs' />"),
          x = {
        "float": "left",
        position: "relative",
        opacity: 1,
        zIndex: 2
      },
          y = {
        "float": "none",
        position: "absolute",
        opacity: 0,
        zIndex: 1
      },
          F = function () {
        var b = (document.body || document.documentElement).style,
            a = "transition";
        if ("string" === typeof b[a]) return !0;
        s = ["Moz", "Webkit", "Khtml", "O", "ms"];
        var a = a.charAt(0).toUpperCase() + a.substr(1),
            c;

        for (c = 0; c < s.length; c++) {
          if ("string" === typeof b[s[c] + a]) return !0;
        }

        return !1;
      }(),
          z = function z(b) {
        a.before(b);
        F ? (e.removeClass(j).css(y).eq(b).addClass(j).css(x), n = b, setTimeout(function () {
          a.after(b);
        }, h)) : e.stop().fadeOut(h, function () {
          c(this).removeClass(j).css(y).css("opacity", 1);
        }).eq(b).fadeIn(h, function () {
          c(this).addClass(j).css(x);
          a.after(b);
          n = b;
        });
      };

      a.random && (e.sort(function () {
        return Math.round(Math.random()) - 0.5;
      }), f.empty().append(e));
      e.each(function (a) {
        this.id = w + a;
      });
      f.addClass(g + " " + d);
      l && l.maxwidth && f.css("max-width", u);
      e.hide().css(y).eq(0).addClass(j).css(x).show();
      F && e.show().css({
        "-webkit-transition": "opacity " + h + "ms ease-in-out",
        "-moz-transition": "opacity " + h + "ms ease-in-out",
        "-o-transition": "opacity " + h + "ms ease-in-out",
        transition: "opacity " + h + "ms ease-in-out"
      });

      if (1 < e.size()) {
        if (D < h + 100) return;

        if (a.pager && !a.manualControls) {
          var A = [];
          e.each(function (a) {
            a += 1;
            A += "<li><a href='#' class='" + w + a + "'>" + a + "</a></li>";
          });
          k.append(A);
          l.navContainer ? c(a.navContainer).append(k) : f.after(k);
        }

        a.manualControls && (k = c(a.manualControls), k.addClass(g + "_tabs " + d + "_tabs"));
        (a.pager || a.manualControls) && k.find("li").each(function (a) {
          c(this).addClass(w + (a + 1));
        });
        if (a.pager || a.manualControls) q = k.find("a"), r = function r(a) {
          q.closest("li").removeClass(v).eq(a).addClass(v);
        };
        a.auto && (t = function t() {
          p = setInterval(function () {
            e.stop(!0, !0);
            var b = n + 1 < C ? n + 1 : 0;
            (a.pager || a.manualControls) && r(b);
            z(b);
          }, D);
        }, t());

        m = function m() {
          a.auto && (clearInterval(p), t());
        };

        a.pause && f.hover(function () {
          clearInterval(p);
        }, function () {
          m();
        });
        if (a.pager || a.manualControls) q.bind("click", function (b) {
          b.preventDefault();
          a.pauseControls || m();
          b = q.index(this);
          n === b || c("." + j).queue("fx").length || (r(b), z(b));
        }).eq(0).closest("li").addClass(v), a.pauseControls && q.hover(function () {
          clearInterval(p);
        }, function () {
          m();
        });

        if (a.nav) {
          g = "<a href='#' class='" + E + " prev'>" + a.prevText + "</a><a href='#' class='" + E + " next'>" + a.nextText + "</a>";
          l.navContainer ? c(a.navContainer).append(g) : f.after(g);
          var d = c("." + d + "_nav"),
              G = d.filter(".prev");
          d.bind("click", function (b) {
            b.preventDefault();
            b = c("." + j);

            if (!b.queue("fx").length) {
              var d = e.index(b);
              b = d - 1;
              d = d + 1 < C ? n + 1 : 0;
              z(c(this)[0] === G[0] ? b : d);
              if (a.pager || a.manualControls) r(c(this)[0] === G[0] ? b : d);
              a.pauseControls || m();
            }
          });
          a.pauseControls && d.hover(function () {
            clearInterval(p);
          }, function () {
            m();
          });
        }
      }

      if ("undefined" === typeof document.body.style.maxWidth && l.maxwidth) {
        var H = function H() {
          f.css("width", "100%");
          f.width() > u && f.css("width", u);
        };

        H();
        c(I).bind("resize", function () {
          H();
        });
      }
    });
  };
})(jQuery, this, 0);
/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(/*! jquery */ "./node_modules/jquery/dist/jquery.js")))

/***/ }),

/***/ "./node_modules/jquery/dist/jquery.js":
/*!********************************************!*\
  !*** ./node_modules/jquery/dist/jquery.js ***!
  \********************************************/
/*! no static exports found */
/***/ (function(module, exports) {

throw new Error("Module build failed (from ./node_modules/babel-loader/lib/index.js):\nSyntaxError: /home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/jquery/dist/jquery.js: Unexpected token, expected \",\" (9992:17)\n\n  9990 | \t\t\t\t\toptions.async,\n  9991 | \t\t\t\t\toptions.username,\n> 9992 | \t\t\t\t\turl.indexOf is not a function\t\toptions.password\n       | \t\t\t\t\t            ^\n  9993 | \t\t\t\t);\n  9994 | \n  9995 | \t\t\t\t// Apply custom fields if provided\n    at Parser._raise (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:746:17)\n    at Parser.raiseWithData (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:739:17)\n    at Parser.raise (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:733:17)\n    at Parser.unexpected (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:8807:16)\n    at Parser.expect (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:8793:28)\n    at Parser.parseCallExpressionArguments (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9830:14)\n    at Parser.parseSubscript (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9750:31)\n    at Parser.parseSubscripts (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9679:19)\n    at Parser.parseExprSubscripts (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9662:17)\n    at Parser.parseMaybeUnary (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9636:21)\n    at Parser.parseExprOps (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9506:23)\n    at Parser.parseMaybeConditional (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9479:23)\n    at Parser.parseMaybeAssign (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9434:21)\n    at Parser.parseExpression (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9386:23)\n    at Parser.parseStatementContent (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11285:23)\n    at Parser.parseStatement (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11156:17)\n    at Parser.parseBlockOrModuleBlockBody (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11731:25)\n    at Parser.parseBlockBody (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11717:10)\n    at Parser.parseBlock (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11701:10)\n    at Parser.parseFunctionBody (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:10708:24)\n    at Parser.parseFunctionBodyAndFinish (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:10691:10)\n    at withTopicForbiddingContext (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11871:12)\n    at Parser.withTopicForbiddingContext (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11031:14)\n    at Parser.parseFunction (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11870:10)\n    at Parser.parseFunctionExpression (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:10171:17)\n    at Parser.parseExprAtom (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:10061:21)\n    at Parser.parseExprSubscripts (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9656:23)\n    at Parser.parseMaybeUnary (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9636:21)\n    at Parser.parseExprOps (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9506:23)\n    at Parser.parseMaybeConditional (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9479:23)");

/***/ })

/******/ });
//# sourceMappingURL=responsiveslides-811563cea6a97062af34.js.map
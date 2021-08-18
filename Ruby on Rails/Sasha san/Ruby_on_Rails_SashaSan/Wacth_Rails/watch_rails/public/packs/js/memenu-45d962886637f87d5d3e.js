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
/******/ 	return __webpack_require__(__webpack_require__.s = "./app/javascript/packs/memenu.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/javascript/packs/memenu.js":
/*!****************************************!*\
  !*** ./app/javascript/packs/memenu.js ***!
  \****************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

/* WEBPACK VAR INJECTION */(function($) {$.fn.memenu = function (e) {
  function r() {
    $(".memenu").find("li, a").unbind();

    if (window.innerWidth <= 768) {
      o();
      s();

      if (n == 0) {
        $(".memenu > li:not(.showhide)").hide(0);
      }
    } else {
      u();
      i();
    }
  }

  function i() {
    $(".memenu li").bind("mouseover", function () {
      $(this).children(".dropdown, .mepanel").stop().fadeIn(t.interval);
    }).bind("mouseleave", function () {
      $(this).children(".dropdown, .mepanel").stop().fadeOut(t.interval);
    });
  }

  function s() {
    $(".memenu > li > a").bind("click", function (e) {
      if ($(this).siblings(".dropdown, .mepanel").css("display") == "none") {
        $(this).siblings(".dropdown, .mepanel").slideDown(t.interval);
        $(this).siblings(".dropdown").find("ul").slideDown(t.interval);
        n = 1;
      } else {
        $(this).siblings(".dropdown, .mepanel").slideUp(t.interval);
      }
    });
  }

  function o() {
    $(".memenu > li.showhide").show(0);
    $(".memenu > li.showhide").bind("click", function () {
      if ($(".memenu > li").is(":hidden")) {
        $(".memenu > li").slideDown(300);
      } else {
        $(".memenu > li:not(.showhide)").slideUp(300);
        $(".memenu > li.showhide").show(0);
      }
    });
  }

  function u() {
    $(".memenu > li").show(0);
    $(".memenu > li.showhide").hide(0);
  }

  var t = {
    interval: 250
  };
  var n = 0;
  $(".memenu").prepend("<li class='showhide'><span class='title'>MENU</span><span class='icon1'></span><span class='icon2'></span></li>");
  r();
  $(window).resize(function () {
    r();
  });
};
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
//# sourceMappingURL=memenu-45d962886637f87d5d3e.js.map
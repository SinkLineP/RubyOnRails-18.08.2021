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
/******/ 	return __webpack_require__(__webpack_require__.s = "./app/javascript/packs/colors.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/javascript/packs/colors.js":
/*!****************************************!*\
  !*** ./app/javascript/packs/colors.js ***!
  \****************************************/
/*! no static exports found */
/***/ (function(module, exports) {

throw new Error("Module build failed (from ./node_modules/babel-loader/lib/index.js):\nSyntaxError: /home/sinkline/Sasha san/Wacth_Rails/watch_rails/app/javascript/packs/colors.js: Unexpected token (11:18)\n\n   9 |   });\n  10 | \n> 11 |   var[ { \"title\": \"James\", \"last_name\": \"Butler\", \"profile_url\": \"/users/78749\",} ]\n     |                   ^\n  12 |   \n  13 |   \n  14 | \n    at Parser._raise (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:757:17)\n    at Parser.raiseWithData (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:750:17)\n    at Parser.raise (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:744:17)\n    at Parser.unexpected (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:8834:16)\n    at Parser.parseIdentifierName (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:10870:18)\n    at Parser.parseIdentifier (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:10847:23)\n    at Parser.parseBindingAtom (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9198:17)\n    at Parser.parseMaybeDefault (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9258:25)\n    at Parser.parseObjectProperty (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:10629:37)\n    at Parser.parseObjPropValue (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:10654:101)\n    at Parser.parseObjectMember (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:10578:10)\n    at Parser.parseObj (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:10487:25)\n    at Parser.parseBindingAtom (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9195:21)\n    at Parser.parseMaybeDefault (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9258:25)\n    at Parser.parseAssignableListItem (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9240:23)\n    at Parser.parseBindingList (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9232:24)\n    at Parser.parseBindingAtom (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:9190:32)\n    at Parser.parseVarId (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11883:20)\n    at Parser.parseVar (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11859:12)\n    at Parser.parseVarStatement (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11671:10)\n    at Parser.parseStatementContent (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11270:21)\n    at Parser.parseStatement (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11203:17)\n    at Parser.parseBlockOrModuleBlockBody (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11778:25)\n    at Parser.parseBlockBody (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11764:10)\n    at Parser.parseTopLevel (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:11134:10)\n    at Parser.parse (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:12836:10)\n    at parse (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/parser/lib/index.js:12889:38)\n    at parser (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/core/lib/parser/index.js:54:34)\n    at parser.next (<anonymous>)\n    at normalizeFile (/home/sinkline/Sasha san/Wacth_Rails/watch_rails/node_modules/@babel/core/lib/transformation/normalize-file.js:93:38)");

/***/ })

/******/ });
//# sourceMappingURL=colors-a2c24db122ad475ba45d.js.map
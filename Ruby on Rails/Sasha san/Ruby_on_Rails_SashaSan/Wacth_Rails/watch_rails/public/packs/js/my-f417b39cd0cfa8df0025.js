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
/******/ 	return __webpack_require__(__webpack_require__.s = "./app/javascript/packs/my.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/javascript/packs/my.js":
/*!************************************!*\
  !*** ./app/javascript/packs/my.js ***!
  \************************************/
/*! no static exports found */
/***/ (function(module, exports) {

// $.ajaxSetup({
//     headers: {
//         'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
//     }
// });
// /* cart */
// $('body').on('click', 'add-to-cart-link', function (e) {
//     e.preventDefault();
//     var product_id = $(this).data('id'),
//         quantity   = $('.quantity input').val() ? $('.quantity input').val() : 1,
//         mod        = $('.available select').var(),
//         access     = $('#cart_access').val();
//         if(access == 99){
//             showCartEmpty()
//             return false
//         }
//         $.ajax({
//             beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token',
//                 $('meta[name="csrf-token"]').attr('content'))},
//             url: $(this).attr('href'),
//             data: {product_id: product_id, quantity: quantity, mod: mod},
//             type: 'POST',
//             success: function (res) {
//                 showCart(res)
//             },
//             error: function () {
//                 alert('Error! Try later!')
//             },
//         });
// });
// $('#cart .modal-body').on('click', '.del-item', function(){
//     var id = $(this).data('id');
//     $.ajax({
//         beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token',
//             $('meta[name="csrf-token"]').attr('content'))},
//         url: "/cart/items/"+id,
//         data: { id: id },
//         method: 'delete',
//         type: 'POST',
//         success: function (res) {
//             showCart(res)
//         },
//         error: function () {
//             alert('Error!')
//         },
//     })
// });
// function showCart(cart) {
//     if($.trim(cart) == '<td>Cart is Empty</td>'){
//         $('#cart .modal-footer a, #cart .modal-footer .btn-danger').css('display', 'none');
//     } else {
//         $('#cart .modal-footer a, #cart .modal-footer .btn-danger').css('display', 'inline-block');
//     }
//     $('#cart .modal-body').html(cart);
//     $('#cart').modal();
//     if($('.cart-sum').text()){
//         $('.simpleCart_total').html($('#cart .cart-sum').text());
//     } else {
//         $('.simpleCart_total').text('Empty Cart');
//     }
// }
// function getCart() {
//     $.ajax({
//         url: '/cart',
//         type: 'GET',
//         success: function (res) {
//             showCart(res)
//         },
//         error: function () {
//             alert('Error! Try later!')
//         },
//     });
// }
// function showCartEmpty() {
//     var result = { error: 'Please sign in! To view the cart.' }
//     var modal = $('#cart').modal();
//     $('#cart .modal-footer a, #cart .modal-footer .btn-danger').css('display', 'none');
//     modal.find('.modal-body').html(result.error)
// }
// function clearCart() {
//     $.ajax({
//         url: '/cart',
//         method: 'delete',
//         type: 'POST',
//         success: function (res) {
//             showCart(res)
//         },
//         error: function () {
//             alert('Error!')
//         }, 
//     });
// }
// // // Search
// // var products = new Bloodhound({
// //     datumTokenizer: Bloodhound.tokenizer.whitespace,
// //     queryTokenizer: Bloodhound.tokenizer.whitespace,
// //     remote: {
// //         wildcart:'%QUERY',
// //         url: '/search?query=%QUERY'
// //     }
// // });
// // products.initialize();
// // $('#typeahead').typeahead({
// //     // hint: false,
// //     highlight: true
// // },{
// //     name: 'products',
// //     display: 'title',
// //     limit: 10,
// //     source: products
// // });
// // $('#typeahead').bind('typeahead:select', function(ev, suggestion) {
// //     //console.log(suggestion);
// //     window.location = '/product/' + encodeURIComponent(suggestion.id);
// // });
// // // ------------------

/***/ })

/******/ });
//# sourceMappingURL=my-f417b39cd0cfa8df0025.js.map
(function() {
  var NodeTypes, ParameterMissing, Utils, createGlobalJsRoutesObject, defaults, root,
    __hasProp = {}.hasOwnProperty;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  ParameterMissing = function(message) {
    this.message = message;
  };

  ParameterMissing.prototype = new Error();

  defaults = {
    prefix: "",
    default_url_options: {}
  };

  NodeTypes = {"GROUP":1,"CAT":2,"SYMBOL":3,"OR":4,"STAR":5,"LITERAL":6,"SLASH":7,"DOT":8};

  Utils = {
    serialize: function(object, prefix) {
      var element, i, key, prop, result, s, _i, _len;

      if (prefix == null) {
        prefix = null;
      }
      if (!object) {
        return "";
      }
      if (!prefix && !(this.get_object_type(object) === "object")) {
        throw new Error("Url parameters should be a javascript hash");
      }
      if (root.jQuery) {
        result = root.jQuery.param(object);
        return (!result ? "" : result);
      }
      s = [];
      switch (this.get_object_type(object)) {
        case "array":
          for (i = _i = 0, _len = object.length; _i < _len; i = ++_i) {
            element = object[i];
            s.push(this.serialize(element, prefix + "[]"));
          }
          break;
        case "object":
          for (key in object) {
            if (!__hasProp.call(object, key)) continue;
            prop = object[key];
            if (!(prop != null)) {
              continue;
            }
            if (prefix != null) {
              key = "" + prefix + "[" + key + "]";
            }
            s.push(this.serialize(prop, key));
          }
          break;
        default:
          if (object) {
            s.push("" + (encodeURIComponent(prefix.toString())) + "=" + (encodeURIComponent(object.toString())));
          }
      }
      if (!s.length) {
        return "";
      }
      return s.join("&");
    },
    clean_path: function(path) {
      var last_index;

      path = path.split("://");
      last_index = path.length - 1;
      path[last_index] = path[last_index].replace(/\/+/g, "/");
      return path.join("://");
    },
    set_default_url_options: function(optional_parts, options) {
      var i, part, _i, _len, _results;

      _results = [];
      for (i = _i = 0, _len = optional_parts.length; _i < _len; i = ++_i) {
        part = optional_parts[i];
        if (!options.hasOwnProperty(part) && defaults.default_url_options.hasOwnProperty(part)) {
          _results.push(options[part] = defaults.default_url_options[part]);
        }
      }
      return _results;
    },
    extract_anchor: function(options) {
      var anchor;

      anchor = "";
      if (options.hasOwnProperty("anchor")) {
        anchor = "#" + options.anchor;
        delete options.anchor;
      }
      return anchor;
    },
    extract_trailing_slash: function(options) {
      var trailing_slash;

      trailing_slash = false;
      if (defaults.default_url_options.hasOwnProperty("trailing_slash")) {
        trailing_slash = defaults.default_url_options.trailing_slash;
      }
      if (options.hasOwnProperty("trailing_slash")) {
        trailing_slash = options.trailing_slash;
        delete options.trailing_slash;
      }
      return trailing_slash;
    },
    extract_options: function(number_of_params, args) {
      var last_el;

      last_el = args[args.length - 1];
      if (args.length > number_of_params || ((last_el != null) && "object" === this.get_object_type(last_el) && !this.look_like_serialized_model(last_el))) {
        return args.pop();
      } else {
        return {};
      }
    },
    look_like_serialized_model: function(object) {
      return "id" in object || "to_param" in object;
    },
    path_identifier: function(object) {
      var property;

      if (object === 0) {
        return "0";
      }
      if (!object) {
        return "";
      }
      property = object;
      if (this.get_object_type(object) === "object") {
        if ("to_param" in object) {
          property = object.to_param;
        } else if ("id" in object) {
          property = object.id;
        } else {
          property = object;
        }
        if (this.get_object_type(property) === "function") {
          property = property.call(object);
        }
      }
      return property.toString();
    },
    clone: function(obj) {
      var attr, copy, key;

      if ((obj == null) || "object" !== this.get_object_type(obj)) {
        return obj;
      }
      copy = obj.constructor();
      for (key in obj) {
        if (!__hasProp.call(obj, key)) continue;
        attr = obj[key];
        copy[key] = attr;
      }
      return copy;
    },
    prepare_parameters: function(required_parameters, actual_parameters, options) {
      var i, result, val, _i, _len;

      result = this.clone(options) || {};
      for (i = _i = 0, _len = required_parameters.length; _i < _len; i = ++_i) {
        val = required_parameters[i];
        if (i < actual_parameters.length) {
          result[val] = actual_parameters[i];
        }
      }
      return result;
    },
    build_path: function(required_parameters, optional_parts, route, args) {
      var anchor, opts, parameters, result, trailing_slash, url, url_params;

      args = Array.prototype.slice.call(args);
      opts = this.extract_options(required_parameters.length, args);
      if (args.length > required_parameters.length) {
        throw new Error("Too many parameters provided for path");
      }
      parameters = this.prepare_parameters(required_parameters, args, opts);
      this.set_default_url_options(optional_parts, parameters);
      anchor = this.extract_anchor(parameters);
      trailing_slash = this.extract_trailing_slash(parameters);
      result = "" + (this.get_prefix()) + (this.visit(route, parameters));
      url = Utils.clean_path("" + result);
      if (trailing_slash === true) {
        url = url.replace(/(.*?)[\/]?$/, "$1/");
      }
      if ((url_params = this.serialize(parameters)).length) {
        url += "?" + url_params;
      }
      url += anchor;
      return url;
    },
    visit: function(route, parameters, optional) {
      var left, left_part, right, right_part, type, value;

      if (optional == null) {
        optional = false;
      }
      type = route[0], left = route[1], right = route[2];
      switch (type) {
        case NodeTypes.GROUP:
          return this.visit(left, parameters, true);
        case NodeTypes.STAR:
          return this.visit_globbing(left, parameters, true);
        case NodeTypes.LITERAL:
        case NodeTypes.SLASH:
        case NodeTypes.DOT:
          return left;
        case NodeTypes.CAT:
          left_part = this.visit(left, parameters, optional);
          right_part = this.visit(right, parameters, optional);
          if (optional && !(left_part && right_part)) {
            return "";
          }
          return "" + left_part + right_part;
        case NodeTypes.SYMBOL:
          value = parameters[left];
          if (value != null) {
            delete parameters[left];
            return this.path_identifier(value);
          }
          if (optional) {
            return "";
          } else {
            throw new ParameterMissing("Route parameter missing: " + left);
          }
          break;
        default:
          throw new Error("Unknown Rails node type");
      }
    },
    build_path_spec: function(route, wildcard) {
      var left, right, type;

      if (wildcard == null) {
        wildcard = false;
      }
      type = route[0], left = route[1], right = route[2];
      switch (type) {
        case NodeTypes.GROUP:
          return "(" + (this.build_path_spec(left)) + ")";
        case NodeTypes.CAT:
          return "" + (this.build_path_spec(left)) + (this.build_path_spec(right));
        case NodeTypes.STAR:
          return this.build_path_spec(left, true);
        case NodeTypes.SYMBOL:
          if (wildcard === true) {
            return "" + (left[0] === '*' ? '' : '*') + left;
          } else {
            return ":" + left;
          }
          break;
        case NodeTypes.SLASH:
        case NodeTypes.DOT:
        case NodeTypes.LITERAL:
          return left;
        default:
          throw new Error("Unknown Rails node type");
      }
    },
    visit_globbing: function(route, parameters, optional) {
      var left, right, type, value;

      type = route[0], left = route[1], right = route[2];
      if (left.replace(/^\*/i, "") !== left) {
        route[1] = left = left.replace(/^\*/i, "");
      }
      value = parameters[left];
      if (value == null) {
        return this.visit(route, parameters, optional);
      }
      parameters[left] = (function() {
        switch (this.get_object_type(value)) {
          case "array":
            return value.join("/");
          default:
            return value;
        }
      }).call(this);
      return this.visit(route, parameters, optional);
    },
    get_prefix: function() {
      var prefix;

      prefix = defaults.prefix;
      if (prefix !== "") {
        prefix = (prefix.match("/$") ? prefix : "" + prefix + "/");
      }
      return prefix;
    },
    route: function(required_parts, optional_parts, route_spec) {
      var path_fn;

      path_fn = function() {
        return Utils.build_path(required_parts, optional_parts, route_spec, arguments);
      };
      path_fn.required_params = required_parts;
      path_fn.toString = function() {
        return Utils.build_path_spec(route_spec);
      };
      return path_fn;
    },
    _classToTypeCache: null,
    _classToType: function() {
      var name, _i, _len, _ref;

      if (this._classToTypeCache != null) {
        return this._classToTypeCache;
      }
      this._classToTypeCache = {};
      _ref = "Boolean Number String Function Array Date RegExp Object Error".split(" ");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        name = _ref[_i];
        this._classToTypeCache["[object " + name + "]"] = name.toLowerCase();
      }
      return this._classToTypeCache;
    },
    get_object_type: function(obj) {
      if (root.jQuery && (root.jQuery.type != null)) {
        return root.jQuery.type(obj);
      }
      if (obj == null) {
        return "" + obj;
      }
      if (typeof obj === "object" || typeof obj === "function") {
        return this._classToType()[Object.prototype.toString.call(obj)] || "object";
      } else {
        return typeof obj;
      }
    }
  };

  createGlobalJsRoutesObject = function() {
    var namespace;

    namespace = function(mainRoot, namespaceString) {
      var current, parts;

      parts = (namespaceString ? namespaceString.split(".") : []);
      if (!parts.length) {
        return;
      }
      current = parts.shift();
      mainRoot[current] = mainRoot[current] || {};
      return namespace(mainRoot[current], parts.join("."));
    };
    namespace(root, "Routes");
    root.Routes = {
// admin => /
  // function(options)
  admin_path: Utils.route([], [], [7,"/",false], arguments),
// admin_about_lookup => /about_lookups/:id(.:format)
  // function(id, options)
  admin_about_lookup_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"about_lookups",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_about_lookups => /about_lookups(.:format)
  // function(options)
  admin_about_lookups_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"about_lookups",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_about_page => /about_pages/:id(.:format)
  // function(id, options)
  admin_about_page_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"about_pages",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_about_pages => /about_pages(.:format)
  // function(options)
  admin_about_pages_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"about_pages",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_administrator => /administrators/:id(.:format)
  // function(id, options)
  admin_administrator_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"administrators",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_administrators => /administrators(.:format)
  // function(options)
  admin_administrators_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"administrators",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_advantage => /advantages/:id(.:format)
  // function(id, options)
  admin_advantage_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"advantages",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_advantages => /advantages(.:format)
  // function(options)
  admin_advantages_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"advantages",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_amo_module => /amo_modules/:id(.:format)
  // function(id, options)
  admin_amo_module_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"amo_modules",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_amo_modules => /amo_modules(.:format)
  // function(options)
  admin_amo_modules_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"amo_modules",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_amocrm_statuses => /amocrm_statuses(.:format)
  // function(options)
  admin_amocrm_statuses_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"amocrm_statuses",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_article => /articles/:id(.:format)
  // function(id, options)
  admin_article_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"articles",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_articles => /articles(.:format)
  // function(options)
  admin_articles_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"articles",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_attendance => /attendance(.:format)
  // function(options)
  admin_attendance_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"attendance",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_attendance_report => /attendance_report(.:format)
  // function(options)
  admin_attendance_report_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"attendance_report",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_automatic_discount => /automatic_discounts/:id(.:format)
  // function(id, options)
  admin_automatic_discount_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"automatic_discounts",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_automatic_discounts => /automatic_discounts(.:format)
  // function(options)
  admin_automatic_discounts_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"automatic_discounts",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_banner => /banners/:id(.:format)
  // function(id, options)
  admin_banner_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"banners",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_banners => /banners(.:format)
  // function(options)
  admin_banners_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"banners",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_block => /blocks/:id(.:format)
  // function(id, options)
  admin_block_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"blocks",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_blocks => /blocks(.:format)
  // function(options)
  admin_blocks_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"blocks",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_book => /books/:id(.:format)
  // function(id, options)
  admin_book_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"books",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_books => /books(.:format)
  // function(options)
  admin_books_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"books",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_business_page => /business_pages/:id(.:format)
  // function(id, options)
  admin_business_page_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"business_pages",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_business_pages => /business_pages(.:format)
  // function(options)
  admin_business_pages_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"business_pages",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_campaign_index => /campaign_indices/:id(.:format)
  // function(id, options)
  admin_campaign_index_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"campaign_indices",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_campaign_indices => /campaign_indices(.:format)
  // function(options)
  admin_campaign_indices_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"campaign_indices",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_campaigns => /campaigns(.:format)
  // function(options)
  admin_campaigns_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"campaigns",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_charges_report => /charges_report(.:format)
  // function(options)
  admin_charges_report_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"charges_report",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_configurator => /configurator(.:format)
  // function(options)
  admin_configurator_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"configurator",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_consultation => /consultations/:id(.:format)
  // function(id, options)
  admin_consultation_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"consultations",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_consultations => /consultations(.:format)
  // function(options)
  admin_consultations_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"consultations",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_contacts_merges => /contacts_merges(.:format)
  // function(options)
  admin_contacts_merges_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"contacts_merges",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_contingents => /contingents(.:format)
  // function(options)
  admin_contingents_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"contingents",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_course => /courses/:id(.:format)
  // function(id, options)
  admin_course_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_course_content => /courses/:course_id/content(.:format)
  // function(course_id, options)
  admin_course_content_path: Utils.route(["course_id"], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[3,"course_id",false],[2,[7,"/",false],[2,[6,"content",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_course_notices => /courses/:course_id/notices(.:format)
  // function(course_id, options)
  admin_course_notices_path: Utils.route(["course_id"], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[3,"course_id",false],[2,[7,"/",false],[2,[6,"notices",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_course_works => /course_works(.:format)
  // function(options)
  admin_course_works_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"course_works",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_courses => /courses(.:format)
  // function(options)
  admin_courses_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_curriculum_block => /curriculum_blocks/:id(.:format)
  // function(id, options)
  admin_curriculum_block_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"curriculum_blocks",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_curriculum_blocks => /curriculum_blocks(.:format)
  // function(options)
  admin_curriculum_blocks_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"curriculum_blocks",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_debtor_reports => /debtor_reports(.:format)
  // function(options)
  admin_debtor_reports_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"debtor_reports",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_discount => /discounts/:id(.:format)
  // function(id, options)
  admin_discount_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"discounts",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_discounts => /discounts(.:format)
  // function(options)
  admin_discounts_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"discounts",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_document => /documents/:id(.:format)
  // function(id, options)
  admin_document_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"documents",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_document_section => /document_sections/:id(.:format)
  // function(id, options)
  admin_document_section_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"document_sections",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_document_sections => /document_sections(.:format)
  // function(options)
  admin_document_sections_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"document_sections",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_documents => /documents(.:format)
  // function(options)
  admin_documents_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"documents",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_download => /download(.:format)
  // function(options)
  admin_download_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"download",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_education_document => /education_documents/:id(.:format)
  // function(id, options)
  admin_education_document_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"education_documents",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_education_document_picture => /education_document_picture(.:format)
  // function(options)
  admin_education_document_picture_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"education_document_picture",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_education_documents => /education_documents(.:format)
  // function(options)
  admin_education_documents_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"education_documents",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_education_forms => /education_forms(.:format)
  // function(options)
  admin_education_forms_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"education_forms",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_education_level => /education_levels/:id(.:format)
  // function(id, options)
  admin_education_level_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"education_levels",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_education_levels => /education_levels(.:format)
  // function(options)
  admin_education_levels_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"education_levels",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_en_page => /en_page(.:format)
  // function(options)
  admin_en_page_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"en_page",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_exercises => /exercises(.:format)
  // function(options)
  admin_exercises_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"exercises",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_faculties => /faculties(.:format)
  // function(options)
  admin_faculties_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"faculties",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_faculty => /faculties/:id(.:format)
  // function(id, options)
  admin_faculty_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"faculties",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_faq => /faq/:id(.:format)
  // function(id, options)
  admin_faq_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"faq",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_faq_index => /faq(.:format)
  // function(options)
  admin_faq_index_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"faq",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_file => /file(.:format)
  // function(options)
  admin_file_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"file",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_funnel => /funnel(.:format)
  // function(options)
  admin_funnel_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"funnel",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_graduate => /graduates/:id(.:format)
  // function(id, options)
  admin_graduate_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"graduates",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_graduates => /graduates(.:format)
  // function(options)
  admin_graduates_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"graduates",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_group => /groups/:id(.:format)
  // function(id, options)
  admin_group_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_group_addition_order => /groups/:group_id/addition_order(.:format)
  // function(group_id, options)
  admin_group_addition_order_path: Utils.route(["group_id"], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[3,"group_id",false],[2,[7,"/",false],[2,[6,"addition_order",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_group_attendance_log => /groups/:group_id/attendance_log(.:format)
  // function(group_id, options)
  admin_group_attendance_log_path: Utils.route(["group_id"], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[3,"group_id",false],[2,[7,"/",false],[2,[6,"attendance_log",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_group_attendance_report => /groups/:group_id/attendance_report(.:format)
  // function(group_id, options)
  admin_group_attendance_report_path: Utils.route(["group_id"], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[3,"group_id",false],[2,[7,"/",false],[2,[6,"attendance_report",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_group_expulsion_order => /groups/:group_id/expulsion_order(.:format)
  // function(group_id, options)
  admin_group_expulsion_order_path: Utils.route(["group_id"], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[3,"group_id",false],[2,[7,"/",false],[2,[6,"expulsion_order",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_group_final_work_registry => /groups/:group_id/final_work_registry(.:format)
  // function(group_id, options)
  admin_group_final_work_registry_path: Utils.route(["group_id"], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[3,"group_id",false],[2,[7,"/",false],[2,[6,"final_work_registry",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_group_group_list => /groups/:group_id/group_list(.:format)
  // function(group_id, options)
  admin_group_group_list_path: Utils.route(["group_id"], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[3,"group_id",false],[2,[7,"/",false],[2,[6,"group_list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_group_group_prices => /groups/:group_id/group_prices(.:format)
  // function(group_id, options)
  admin_group_group_prices_path: Utils.route(["group_id"], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[3,"group_id",false],[2,[7,"/",false],[2,[6,"group_prices",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_group_subscription_attendance_report => /group_subscriptions/:group_subscription_id/attendance_report(.:format)
  // function(group_subscription_id, options)
  admin_group_subscription_attendance_report_path: Utils.route(["group_subscription_id"], ["format"], [2,[7,"/",false],[2,[6,"group_subscriptions",false],[2,[7,"/",false],[2,[3,"group_subscription_id",false],[2,[7,"/",false],[2,[6,"attendance_report",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_group_subscription_certificate => /group_subscriptions/:group_subscription_id/certificate(.:format)
  // function(group_subscription_id, options)
  admin_group_subscription_certificate_path: Utils.route(["group_subscription_id"], ["format"], [2,[7,"/",false],[2,[6,"group_subscriptions",false],[2,[7,"/",false],[2,[3,"group_subscription_id",false],[2,[7,"/",false],[2,[6,"certificate",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_group_subscription_contract => /group_subscriptions/:group_subscription_id/contract(.:format)
  // function(group_subscription_id, options)
  admin_group_subscription_contract_path: Utils.route(["group_subscription_id"], ["format"], [2,[7,"/",false],[2,[6,"group_subscriptions",false],[2,[7,"/",false],[2,[3,"group_subscription_id",false],[2,[7,"/",false],[2,[6,"contract",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_group_subscriptions => /group_subscriptions(.:format)
  // function(options)
  admin_group_subscriptions_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"group_subscriptions",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_groups => /groups(.:format)
  // function(options)
  admin_groups_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_history_event => /history_events/:id(.:format)
  // function(id, options)
  admin_history_event_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"history_events",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_history_events => /history_events(.:format)
  // function(options)
  admin_history_events_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"history_events",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_holiday => /holidays/:id(.:format)
  // function(id, options)
  admin_holiday_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"holidays",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_holidays => /holidays(.:format)
  // function(options)
  admin_holidays_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"holidays",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_images => /images(.:format)
  // function(options)
  admin_images_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"images",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_indices => /indices(.:format)
  // function(options)
  admin_indices_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"indices",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_institution_block => /institution_blocks/:id(.:format)
  // function(id, options)
  admin_institution_block_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"institution_blocks",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_institution_blocks => /institution_blocks(.:format)
  // function(options)
  admin_institution_blocks_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"institution_blocks",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_instructor => /instructors/:id(.:format)
  // function(id, options)
  admin_instructor_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"instructors",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_instructors => /instructors(.:format)
  // function(options)
  admin_instructors_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"instructors",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_letter => /letters/:id(.:format)
  // function(id, options)
  admin_letter_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"letters",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_letters => /letters(.:format)
  // function(options)
  admin_letters_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"letters",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_magazine_payment_type => /magazine_payment_types/:id(.:format)
  // function(id, options)
  admin_magazine_payment_type_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"magazine_payment_types",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_magazine_payment_types => /magazine_payment_types(.:format)
  // function(options)
  admin_magazine_payment_types_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"magazine_payment_types",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_manager => /managers/:id(.:format)
  // function(id, options)
  admin_manager_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"managers",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_managers => /managers(.:format)
  // function(options)
  admin_managers_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"managers",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_material_cover => /material_cover(.:format)
  // function(options)
  admin_material_cover_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"material_cover",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_meta_tag => /meta_tags/:id(.:format)
  // function(id, options)
  admin_meta_tag_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"meta_tags",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_meta_tags => /meta_tags(.:format)
  // function(options)
  admin_meta_tags_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"meta_tags",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_modules_report => /modules_report(.:format)
  // function(options)
  admin_modules_report_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"modules_report",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_my_student => /my_students/:id(.:format)
  // function(id, options)
  admin_my_student_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"my_students",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_my_student_result => /my_students/:my_student_id/results/:id(.:format)
  // function(my_student_id, id, options)
  admin_my_student_result_path: Utils.route(["my_student_id","id"], ["format"], [2,[7,"/",false],[2,[6,"my_students",false],[2,[7,"/",false],[2,[3,"my_student_id",false],[2,[7,"/",false],[2,[6,"results",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// admin_my_students => /my_students(.:format)
  // function(options)
  admin_my_students_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"my_students",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_offer => /offers/:id(.:format)
  // function(id, options)
  admin_offer_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"offers",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_offers => /offers(.:format)
  // function(options)
  admin_offers_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"offers",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_order_contract => /orders/:order_id/contract(.:format)
  // function(order_id, options)
  admin_order_contract_path: Utils.route(["order_id"], ["format"], [2,[7,"/",false],[2,[6,"orders",false],[2,[7,"/",false],[2,[3,"order_id",false],[2,[7,"/",false],[2,[6,"contract",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_our_advantage => /our_advantages/:id(.:format)
  // function(id, options)
  admin_our_advantage_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"our_advantages",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_our_advantages => /our_advantages(.:format)
  // function(options)
  admin_our_advantages_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"our_advantages",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_partner => /partners/:id(.:format)
  // function(id, options)
  admin_partner_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"partners",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_partners => /partners(.:format)
  // function(options)
  admin_partners_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"partners",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_payment_statistics => /payment_statistics(.:format)
  // function(options)
  admin_payment_statistics_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"payment_statistics",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_payments_reports => /payments_reports(.:format)
  // function(options)
  admin_payments_reports_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"payments_reports",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_pdf => /pdf(.:format)
  // function(options)
  admin_pdf_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"pdf",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_period_orders => /period_orders(.:format)
  // function(options)
  admin_period_orders_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"period_orders",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_post => /posts/:id(.:format)
  // function(id, options)
  admin_post_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"posts",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_post_categories => /post_categories(.:format)
  // function(options)
  admin_post_categories_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"post_categories",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_posts => /posts(.:format)
  // function(options)
  admin_posts_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"posts",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_practice_bases => /practice_bases(.:format)
  // function(options)
  admin_practice_bases_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"practice_bases",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_practice_basis => /practice_bases/:id(.:format)
  // function(id, options)
  admin_practice_basis_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"practice_bases",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_privacy_policy => /privacy_policy/:id(.:format)
  // function(id, options)
  admin_privacy_policy_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"privacy_policy",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_privacy_policy_index => /privacy_policy(.:format)
  // function(options)
  admin_privacy_policy_index_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"privacy_policy",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_private_file => /private_file(.:format)
  // function(options)
  admin_private_file_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"private_file",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_promo_code => /promo_codes/:id(.:format)
  // function(id, options)
  admin_promo_code_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"promo_codes",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_promo_codes => /promo_codes(.:format)
  // function(options)
  admin_promo_codes_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"promo_codes",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_promotion => /promotions/:id(.:format)
  // function(id, options)
  admin_promotion_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"promotions",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_promotions => /promotions(.:format)
  // function(options)
  admin_promotions_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"promotions",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_question_image => /question_image(.:format)
  // function(options)
  admin_question_image_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"question_image",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_ratings => /ratings(.:format)
  // function(options)
  admin_ratings_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"ratings",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_recall => /recalls/:id(.:format)
  // function(id, options)
  admin_recall_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"recalls",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_recalls => /recalls(.:format)
  // function(options)
  admin_recalls_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"recalls",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_result_comment => /results/:result_id/comment(.:format)
  // function(result_id, options)
  admin_result_comment_path: Utils.route(["result_id"], ["format"], [2,[7,"/",false],[2,[6,"results",false],[2,[7,"/",false],[2,[3,"result_id",false],[2,[7,"/",false],[2,[6,"comment",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_reward_image => /reward_images/:id(.:format)
  // function(id, options)
  admin_reward_image_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"reward_images",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_reward_images => /reward_images(.:format)
  // function(options)
  admin_reward_images_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"reward_images",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_search => /search(.:format)
  // function(options)
  admin_search_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"search",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_search_bank => /banks/search(.:format)
  // function(options)
  admin_search_bank_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"banks",false],[2,[7,"/",false],[2,[6,"search",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_search_users => /users/search(.:format)
  // function(options)
  admin_search_users_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"search",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_service => /services/:id(.:format)
  // function(id, options)
  admin_service_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"services",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_services => /services(.:format)
  // function(options)
  admin_services_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"services",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_skill => /skills/:id(.:format)
  // function(id, options)
  admin_skill_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"skills",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_skills => /skills(.:format)
  // function(options)
  admin_skills_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"skills",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_social_lookup => /social_lookups/:id(.:format)
  // function(id, options)
  admin_social_lookup_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"social_lookups",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_social_lookups => /social_lookups(.:format)
  // function(options)
  admin_social_lookups_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"social_lookups",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_specialities => /specialities(.:format)
  // function(options)
  admin_specialities_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"specialities",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_speciality => /specialities/:id(.:format)
  // function(id, options)
  admin_speciality_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"specialities",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_static_page => /static_pages/:id(.:format)
  // function(id, options)
  admin_static_page_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"static_pages",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_static_pages => /static_pages(.:format)
  // function(options)
  admin_static_pages_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"static_pages",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_student => /students/:id(.:format)
  // function(id, options)
  admin_student_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_student_group_subscription => /students/:student_id/group_subscriptions/:id(.:format)
  // function(student_id, id, options)
  admin_student_group_subscription_path: Utils.route(["student_id","id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"student_id",false],[2,[7,"/",false],[2,[6,"group_subscriptions",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// admin_student_group_subscriptions => /students/:student_id/group_subscriptions(.:format)
  // function(student_id, options)
  admin_student_group_subscriptions_path: Utils.route(["student_id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"student_id",false],[2,[7,"/",false],[2,[6,"group_subscriptions",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_student_order => /students/:student_id/orders/:id(.:format)
  // function(student_id, id, options)
  admin_student_order_path: Utils.route(["student_id","id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"student_id",false],[2,[7,"/",false],[2,[6,"orders",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// admin_student_orders => /students/:student_id/orders(.:format)
  // function(student_id, options)
  admin_student_orders_path: Utils.route(["student_id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"student_id",false],[2,[7,"/",false],[2,[6,"orders",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_student_payment_log => /students/:student_id/payment_logs/:id(.:format)
  // function(student_id, id, options)
  admin_student_payment_log_path: Utils.route(["student_id","id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"student_id",false],[2,[7,"/",false],[2,[6,"payment_logs",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// admin_student_payment_logs => /students/:student_id/payment_logs(.:format)
  // function(student_id, options)
  admin_student_payment_logs_path: Utils.route(["student_id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"student_id",false],[2,[7,"/",false],[2,[6,"payment_logs",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// admin_student_work_results => /student_work_results(.:format)
  // function(options)
  admin_student_work_results_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"student_work_results",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_students => /students(.:format)
  // function(options)
  admin_students_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"students",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_survey_responses => /survey_responses(.:format)
  // function(options)
  admin_survey_responses_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"survey_responses",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_tour_image => /tour_images/:id(.:format)
  // function(id, options)
  admin_tour_image_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"tour_images",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_tour_images => /tour_images(.:format)
  // function(options)
  admin_tour_images_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"tour_images",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_tutorial => /tutorial(.:format)
  // function(options)
  admin_tutorial_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"tutorial",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_uploaded_video => /uploaded_videos/:id(.:format)
  // function(id, options)
  admin_uploaded_video_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"uploaded_videos",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_uploaded_videos => /uploaded_videos(.:format)
  // function(options)
  admin_uploaded_videos_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"uploaded_videos",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_used_time => /used_times/:id(.:format)
  // function(id, options)
  admin_used_time_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"used_times",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_used_times => /used_times(.:format)
  // function(options)
  admin_used_times_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"used_times",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_vacancy_group => /vacancy_groups/:id(.:format)
  // function(id, options)
  admin_vacancy_group_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"vacancy_groups",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_vacancy_groups => /vacancy_groups(.:format)
  // function(options)
  admin_vacancy_groups_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"vacancy_groups",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_verification_tutorial => /verification_tutorial(.:format)
  // function(options)
  admin_verification_tutorial_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"verification_tutorial",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_work => /works/:id(.:format)
  // function(id, options)
  admin_work_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"works",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_work_result => /work_results/:id(.:format)
  // function(id, options)
  admin_work_result_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"work_results",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// admin_work_results => /work_results(.:format)
  // function(options)
  admin_work_results_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"work_results",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// admin_works => /works(.:format)
  // function(options)
  admin_works_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"works",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// amo_contacts => /amo/contacts(.:format)
  // function(options)
  amo_contacts_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"amo",false],[2,[7,"/",false],[2,[6,"contacts",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// amo_leads => /amo/leads(.:format)
  // function(options)
  amo_leads_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"amo",false],[2,[7,"/",false],[2,[6,"leads",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// blog => /blog(/:filter)(.:format)
  // function(options)
  blog_path: Utils.route([], ["filter","format"], [2,[7,"/",false],[2,[6,"blog",false],[2,[1,[2,[7,"/",false],[3,"filter",false]],false],[1,[2,[8,".",false],[3,"format",false]],false]]]], arguments),
// blog_category => /blog/categories/:category_id(/:filter)(.:format)
  // function(category_id, options)
  blog_category_path: Utils.route(["category_id"], ["filter","format"], [2,[7,"/",false],[2,[6,"blog",false],[2,[7,"/",false],[2,[6,"categories",false],[2,[7,"/",false],[2,[3,"category_id",false],[2,[1,[2,[7,"/",false],[3,"filter",false]],false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]], arguments),
// blog_post => /blog/posts/:id(.:format)
  // function(id, options)
  blog_post_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"blog",false],[2,[7,"/",false],[2,[6,"posts",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// blog_subscribers => /blog_subscribers(.:format)
  // function(options)
  blog_subscribers_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"blog_subscribers",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// book => /books/:id(.:format)
  // function(id, options)
  book_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"books",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// books => /books(.:format)
  // function(options)
  books_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"books",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// calculate_api_price_calculator => /api/price_calculator/calculate(.:format)
  // function(options)
  calculate_api_price_calculator_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"api",false],[2,[7,"/",false],[2,[6,"price_calculator",false],[2,[7,"/",false],[2,[6,"calculate",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// call_results => /call_results(.:format)
  // function(options)
  call_results_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"call_results",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// cancel_courses_shop_user_registration => /users/cancel(.:format)
  // function(options)
  cancel_courses_shop_user_registration_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"cancel",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// change_admin_module_groups => /module_groups/change(.:format)
  // function(options)
  change_admin_module_groups_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"module_groups",false],[2,[7,"/",false],[2,[6,"change",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// change_password_admin_instructor => /instructors/:id/change_password(.:format)
  // function(id, options)
  change_password_admin_instructor_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"instructors",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"change_password",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// change_status_amo_leads => /amo/leads/change_status(.:format)
  // function(options)
  change_status_amo_leads_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"amo",false],[2,[7,"/",false],[2,[6,"leads",false],[2,[7,"/",false],[2,[6,"change_status",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// check_courses_shop_promo_codes => /promo_codes/check(.:format)
  // function(options)
  check_courses_shop_promo_codes_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"promo_codes",false],[2,[7,"/",false],[2,[6,"check",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// ckeditor.pictures => /ckeditor/pictures(.:format)
  // function(options)
  ckeditor_pictures_path: Utils.route([], ["format"], [2,[2,[2,[7,"/",false],[6,"ckeditor",false]],[7,"/",false]],[2,[6,"pictures",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// ckeditor.picture => /ckeditor/pictures/:id(.:format)
  // function(id, options)
  ckeditor_picture_path: Utils.route(["id"], ["format"], [2,[2,[2,[7,"/",false],[6,"ckeditor",false]],[7,"/",false]],[2,[6,"pictures",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// ckeditor.attachment_files => /ckeditor/attachment_files(.:format)
  // function(options)
  ckeditor_attachment_files_path: Utils.route([], ["format"], [2,[2,[2,[7,"/",false],[6,"ckeditor",false]],[7,"/",false]],[2,[6,"attachment_files",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// ckeditor.attachment_file => /ckeditor/attachment_files/:id(.:format)
  // function(id, options)
  ckeditor_attachment_file_path: Utils.route(["id"], ["format"], [2,[2,[2,[7,"/",false],[6,"ckeditor",false]],[7,"/",false]],[2,[6,"attachment_files",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// clone_admin_block => /blocks/:id/clone(.:format)
  // function(id, options)
  clone_admin_block_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"blocks",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"clone",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// clone_admin_group => /groups/:id/clone(.:format)
  // function(id, options)
  clone_admin_group_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"clone",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// confirm_courses_shop_privacy_policy => /privacy_policy/confirm(.:format)
  // function(options)
  confirm_courses_shop_privacy_policy_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"privacy_policy",false],[2,[7,"/",false],[2,[6,"confirm",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// course => /courses/:id(.:format)
  // function(id, options)
  course_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// course_lecture => /courses/:course_id/lectures/:id(.:format)
  // function(course_id, id, options)
  course_lecture_path: Utils.route(["course_id","id"], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[3,"course_id",false],[2,[7,"/",false],[2,[6,"lectures",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// course_result => /courses/:course_id/results/:id(.:format)
  // function(course_id, id, options)
  course_result_path: Utils.route(["course_id","id"], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[3,"course_id",false],[2,[7,"/",false],[2,[6,"results",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// course_task => /courses/:course_id/tasks/:id(.:format)
  // function(course_id, id, options)
  course_task_path: Utils.route(["course_id","id"], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[3,"course_id",false],[2,[7,"/",false],[2,[6,"tasks",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// courses_shop => /robots.txt(.:format)
  // function(options)
  courses_shop_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"robots",false],[2,[8,".",false],[2,[6,"txt",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_about_partners => /about/partners(.:format)
  // function(options)
  courses_shop_about_partners_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"about",false],[2,[7,"/",false],[2,[6,"partners",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_blog => /blogs/:id(.:format)
  // function(id, options)
  courses_shop_blog_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"blogs",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_blogs => /blogs(.:format)
  // function(options)
  courses_shop_blogs_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"blogs",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_cart => /cart(.:format)
  // function(options)
  courses_shop_cart_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"cart",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_cecutient_version => /about/cecutient_version(.:format)
  // function(options)
  courses_shop_cecutient_version_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"about",false],[2,[7,"/",false],[2,[6,"cecutient_version",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_configurator => /configurator(.:format)
  // function(options)
  courses_shop_configurator_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"configurator",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_consulting => /business/consulting(.:format)
  // function(options)
  courses_shop_consulting_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"business",false],[2,[7,"/",false],[2,[6,"consulting",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_contacts => /contacts(.:format)
  // function(options)
  courses_shop_contacts_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"contacts",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_cookies_policy => /cookies_policy(.:format)
  // function(options)
  courses_shop_cookies_policy_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"cookies_policy",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_corporate_education => /business/corporate_education(.:format)
  // function(options)
  courses_shop_corporate_education_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"business",false],[2,[7,"/",false],[2,[6,"corporate_education",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_course => /:speciality_id/:id(.:format)
  // function(speciality_id, id, options)
  courses_shop_course_path: Utils.route(["speciality_id","id"], ["format"], [2,[7,"/",false],[2,[3,"speciality_id",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_course_consultations => /courses/:course_id/consultations(.:format)
  // function(course_id, options)
  courses_shop_course_consultations_path: Utils.route(["course_id"], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[3,"course_id",false],[2,[7,"/",false],[2,[6,"consultations",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// courses_shop_diploma => /about/diploma(.:format)
  // function(options)
  courses_shop_diploma_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"about",false],[2,[7,"/",false],[2,[6,"diploma",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_faqs => /faqs(.:format)
  // function(options)
  courses_shop_faqs_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"faqs",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_graduates => /about/graduates(.:format)
  // function(options)
  courses_shop_graduates_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"about",false],[2,[7,"/",false],[2,[6,"graduates",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_group => /groups/:id(.:format)
  // function(id, options)
  courses_shop_group_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_group_subscription => /group_subscriptions/:id(.:format)
  // function(id, options)
  courses_shop_group_subscription_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"group_subscriptions",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_group_subscriptions => /group_subscriptions(.:format)
  // function(options)
  courses_shop_group_subscriptions_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"group_subscriptions",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_history => /about/history(.:format)
  // function(options)
  courses_shop_history_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"about",false],[2,[7,"/",false],[2,[6,"history",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_institution_blocks => /info(.:format)
  // function(options)
  courses_shop_institution_blocks_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"info",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_license => /license(.:format)
  // function(options)
  courses_shop_license_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"license",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_manufacturers_and_dealers => /business/manufacturers_and_dealers(.:format)
  // function(options)
  courses_shop_manufacturers_and_dealers_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"business",false],[2,[7,"/",false],[2,[6,"manufacturers_and_dealers",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_about => /markup/about(.:format)
  // function(options)
  courses_shop_markup_about_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"about",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_article => /markup/article(.:format)
  // function(options)
  courses_shop_markup_article_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"article",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_articles => /markup/articles(.:format)
  // function(options)
  courses_shop_markup_articles_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"articles",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_basket => /markup/basket(.:format)
  // function(options)
  courses_shop_markup_basket_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"basket",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_configurator_results => /markup/configurator_results(.:format)
  // function(options)
  courses_shop_markup_configurator_results_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"configurator_results",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_contacts => /markup/contacts(.:format)
  // function(options)
  courses_shop_markup_contacts_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"contacts",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_course => /markup/course(.:format)
  // function(options)
  courses_shop_markup_course_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"course",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_course_added => /markup/course_added(.:format)
  // function(options)
  courses_shop_markup_course_added_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"course_added",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_courses => /markup/courses(.:format)
  // function(options)
  courses_shop_markup_courses_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"courses",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_demo => /markup/demo(.:format)
  // function(options)
  courses_shop_markup_demo_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"demo",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_disability => /markup/disability(.:format)
  // function(options)
  courses_shop_markup_disability_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"disability",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_error => /markup/error(.:format)
  // function(options)
  courses_shop_markup_error_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"error",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_faq => /markup/faq(.:format)
  // function(options)
  courses_shop_markup_faq_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"faq",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_feedbacks => /markup/feedbacks(.:format)
  // function(options)
  courses_shop_markup_feedbacks_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"feedbacks",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_for_business => /markup/for_business(.:format)
  // function(options)
  courses_shop_markup_for_business_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"for_business",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_index => /markup/index(.:format)
  // function(options)
  courses_shop_markup_index_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"index",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_info => /markup/info(.:format)
  // function(options)
  courses_shop_markup_info_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"info",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_licenses => /markup/licenses(.:format)
  // function(options)
  courses_shop_markup_licenses_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"licenses",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_mass_media => /markup/mass_media(.:format)
  // function(options)
  courses_shop_markup_mass_media_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"mass_media",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_models => /markup/models(.:format)
  // function(options)
  courses_shop_markup_models_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"models",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_offer => /markup/offer(.:format)
  // function(options)
  courses_shop_markup_offer_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"offer",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_personal_cabinet_courses => /markup/personal_cabinet_courses(.:format)
  // function(options)
  courses_shop_markup_personal_cabinet_courses_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"personal_cabinet_courses",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_personal_cabinet_documents => /markup/personal_cabinet_documents(.:format)
  // function(options)
  courses_shop_markup_personal_cabinet_documents_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"personal_cabinet_documents",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_personal_cabinet_schedule => /markup/personal_cabinet_schedule(.:format)
  // function(options)
  courses_shop_markup_personal_cabinet_schedule_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"personal_cabinet_schedule",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_personal_cabinet_settings => /markup/personal_cabinet_settings(.:format)
  // function(options)
  courses_shop_markup_personal_cabinet_settings_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"personal_cabinet_settings",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_promotions => /markup/promotions(.:format)
  // function(options)
  courses_shop_markup_promotions_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"promotions",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_markup_search_results => /markup/search_results(.:format)
  // function(options)
  courses_shop_markup_search_results_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"markup",false],[2,[7,"/",false],[2,[6,"search_results",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_mass_media => /business/mass_media(.:format)
  // function(options)
  courses_shop_mass_media_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"business",false],[2,[7,"/",false],[2,[6,"mass_media",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_mass_media_section => /mass_media/:id(.:format)
  // function(id, options)
  courses_shop_mass_media_section_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"mass_media",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_mass_media_section_index => /mass_media(.:format)
  // function(options)
  courses_shop_mass_media_section_index_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"mass_media",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_models => /models(.:format)
  // function(options)
  courses_shop_models_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"models",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_offer => /offer(.:format)
  // function(options)
  courses_shop_offer_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"offer",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_old_url => /*url/:id(.:format)
  // function(url, id, options)
  courses_shop_old_url_path: Utils.route(["url","id"], ["format"], [2,[7,"/",false],[2,[5,[3,"*url",false],false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_orders => /orders(.:format)
  // function(options)
  courses_shop_orders_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"orders",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_partners => /business/partners(.:format)
  // function(options)
  courses_shop_partners_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"business",false],[2,[7,"/",false],[2,[6,"partners",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_phones => /phones(.:format)
  // function(options)
  courses_shop_phones_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"phones",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_privacy_policy => /privacy_policy(.:format)
  // function(options)
  courses_shop_privacy_policy_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"privacy_policy",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_procedure_requests => /procedure_requests(.:format)
  // function(options)
  courses_shop_procedure_requests_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"procedure_requests",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_profile => /profile(.:format)
  // function(options)
  courses_shop_profile_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"profile",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_profile_courses => /profile/courses(.:format)
  // function(options)
  courses_shop_profile_courses_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"profile",false],[2,[7,"/",false],[2,[6,"courses",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_profile_document => /profile/documents/:id(.:format)
  // function(id, options)
  courses_shop_profile_document_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"profile",false],[2,[7,"/",false],[2,[6,"documents",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// courses_shop_profile_documents => /profile/documents(.:format)
  // function(options)
  courses_shop_profile_documents_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"profile",false],[2,[7,"/",false],[2,[6,"documents",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_profile_schedule => /profile/schedule(.:format)
  // function(options)
  courses_shop_profile_schedule_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"profile",false],[2,[7,"/",false],[2,[6,"schedule",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_promotion_info => /promotion_info(.:format)
  // function(options)
  courses_shop_promotion_info_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"promotion_info",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_promotions => /promotions(.:format)
  // function(options)
  courses_shop_promotions_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"promotions",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_recalls => /recalls(.:format)
  // function(options)
  courses_shop_recalls_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"recalls",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_recruitment => /business/recruitment(.:format)
  // function(options)
  courses_shop_recruitment_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"business",false],[2,[7,"/",false],[2,[6,"recruitment",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_regional_schools => /business/regional_schools(.:format)
  // function(options)
  courses_shop_regional_schools_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"business",false],[2,[7,"/",false],[2,[6,"regional_schools",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_root => /
  // function(options)
  courses_shop_root_path: Utils.route([], [], [7,"/",false], arguments),
// courses_shop_science_and_drk => /science_and_drks/:id(.:format)
  // function(id, options)
  courses_shop_science_and_drk_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"science_and_drks",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_science_and_drks => /science_and_drks(.:format)
  // function(options)
  courses_shop_science_and_drks_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"science_and_drks",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_search => /search(.:format)
  // function(options)
  courses_shop_search_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"search",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_shop_info => /shop_info(.:format)
  // function(options)
  courses_shop_shop_info_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"shop_info",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_social => /social(.:format)
  // function(options)
  courses_shop_social_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"social",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_speciality => (/:root_id)/:id(.:format)
  // function(id, options)
  courses_shop_speciality_path: Utils.route(["id"], ["root_id","format"], [2,[1,[2,[7,"/",false],[3,"root_id",false]],false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]], arguments),
// courses_shop_teachers => /about/teachers(.:format)
  // function(options)
  courses_shop_teachers_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"about",false],[2,[7,"/",false],[2,[6,"teachers",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_tour => /about/tour(.:format)
  // function(options)
  courses_shop_tour_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"about",false],[2,[7,"/",false],[2,[6,"tour",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_user_omniauth_authorize => /users/auth/:provider(.:format)
  // function(provider, options)
  courses_shop_user_omniauth_authorize_path: Utils.route(["provider"], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"auth",false],[2,[7,"/",false],[2,[3,"provider",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// courses_shop_user_omniauth_callback => /users/auth/:action/callback(.:format)
  // function(action, options)
  courses_shop_user_omniauth_callback_path: Utils.route(["action"], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"auth",false],[2,[7,"/",false],[2,[3,"action",false],[2,[7,"/",false],[2,[6,"callback",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// courses_shop_user_password => /users/password(.:format)
  // function(options)
  courses_shop_user_password_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"password",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// courses_shop_user_questions => /user_questions(.:format)
  // function(options)
  courses_shop_user_questions_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"user_questions",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_user_registration => /users(.:format)
  // function(options)
  courses_shop_user_registration_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// courses_shop_user_session => /users/sign_in(.:format)
  // function(options)
  courses_shop_user_session_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"sign_in",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// cover_create_admin_books => /books/cover_create(.:format)
  // function(options)
  cover_create_admin_books_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"books",false],[2,[7,"/",false],[2,[6,"cover_create",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// delete_amo_contacts => /amo/contacts/delete(.:format)
  // function(options)
  delete_amo_contacts_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"amo",false],[2,[7,"/",false],[2,[6,"contacts",false],[2,[7,"/",false],[2,[6,"delete",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// destroy_courses_shop_user_session => /users/sign_out(.:format)
  // function(options)
  destroy_courses_shop_user_session_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"sign_out",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// destroy_user_session => /users/sign_out(.:format)
  // function(options)
  destroy_user_session_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"sign_out",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// document_verification => /document_verification(.:format)
  // function(options)
  document_verification_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"document_verification",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// download_admin_generated_document => /generated_documents/:id/download(.:format)
  // function(id, options)
  download_admin_generated_document_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"generated_documents",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"download",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// download_document_courses_shop_profile_courses => /profile/courses/download_document(.:format)
  // function(options)
  download_document_courses_shop_profile_courses_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"profile",false],[2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[6,"download_document",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// download_empty_sheet_admin_generated_document => /generated_documents/:id/download_empty_sheet(.:format)
  // function(id, options)
  download_empty_sheet_admin_generated_document_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"generated_documents",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"download_empty_sheet",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_about_lookup => /about_lookups/:id/edit(.:format)
  // function(id, options)
  edit_admin_about_lookup_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"about_lookups",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_about_page => /about_pages/:id/edit(.:format)
  // function(id, options)
  edit_admin_about_page_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"about_pages",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_administrator => /administrators/:id/edit(.:format)
  // function(id, options)
  edit_admin_administrator_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"administrators",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_advantage => /advantages/:id/edit(.:format)
  // function(id, options)
  edit_admin_advantage_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"advantages",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_amo_module => /amo_modules/:id/edit(.:format)
  // function(id, options)
  edit_admin_amo_module_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"amo_modules",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_article => /articles/:id/edit(.:format)
  // function(id, options)
  edit_admin_article_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"articles",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_automatic_discount => /automatic_discounts/:id/edit(.:format)
  // function(id, options)
  edit_admin_automatic_discount_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"automatic_discounts",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_banner => /banners/:id/edit(.:format)
  // function(id, options)
  edit_admin_banner_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"banners",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_block => /blocks/:id/edit(.:format)
  // function(id, options)
  edit_admin_block_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"blocks",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_book => /books/:id/edit(.:format)
  // function(id, options)
  edit_admin_book_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"books",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_business_page => /business_pages/:id/edit(.:format)
  // function(id, options)
  edit_admin_business_page_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"business_pages",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_campaign_index => /campaign_indices/:id/edit(.:format)
  // function(id, options)
  edit_admin_campaign_index_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"campaign_indices",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_configurator => /configurator/edit(.:format)
  // function(options)
  edit_admin_configurator_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"configurator",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// edit_admin_consultation => /consultations/:id/edit(.:format)
  // function(id, options)
  edit_admin_consultation_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"consultations",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_course => /courses/:id/edit(.:format)
  // function(id, options)
  edit_admin_course_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_course_content => /courses/:course_id/content/edit(.:format)
  // function(course_id, options)
  edit_admin_course_content_path: Utils.route(["course_id"], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[3,"course_id",false],[2,[7,"/",false],[2,[6,"content",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// edit_admin_curriculum_block => /curriculum_blocks/:id/edit(.:format)
  // function(id, options)
  edit_admin_curriculum_block_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"curriculum_blocks",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_discount => /discounts/:id/edit(.:format)
  // function(id, options)
  edit_admin_discount_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"discounts",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_document => /documents/:id/edit(.:format)
  // function(id, options)
  edit_admin_document_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"documents",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_document_section => /document_sections/:id/edit(.:format)
  // function(id, options)
  edit_admin_document_section_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"document_sections",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_education_document => /education_documents/:id/edit(.:format)
  // function(id, options)
  edit_admin_education_document_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"education_documents",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_education_level => /education_levels/:id/edit(.:format)
  // function(id, options)
  edit_admin_education_level_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"education_levels",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_en_page => /en_page/edit(.:format)
  // function(options)
  edit_admin_en_page_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"en_page",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// edit_admin_faculty => /faculties/:id/edit(.:format)
  // function(id, options)
  edit_admin_faculty_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"faculties",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_faq => /faq/:id/edit(.:format)
  // function(id, options)
  edit_admin_faq_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"faq",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_graduate => /graduates/:id/edit(.:format)
  // function(id, options)
  edit_admin_graduate_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"graduates",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_group => /groups/:id/edit(.:format)
  // function(id, options)
  edit_admin_group_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_history_event => /history_events/:id/edit(.:format)
  // function(id, options)
  edit_admin_history_event_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"history_events",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_institution_block => /institution_blocks/:id/edit(.:format)
  // function(id, options)
  edit_admin_institution_block_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"institution_blocks",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_instructor => /instructors/:id/edit(.:format)
  // function(id, options)
  edit_admin_instructor_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"instructors",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_magazine_payment_type => /magazine_payment_types/:id/edit(.:format)
  // function(id, options)
  edit_admin_magazine_payment_type_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"magazine_payment_types",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_manager => /managers/:id/edit(.:format)
  // function(id, options)
  edit_admin_manager_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"managers",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_meta_tag => /meta_tags/:id/edit(.:format)
  // function(id, options)
  edit_admin_meta_tag_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"meta_tags",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_offer => /offers/:id/edit(.:format)
  // function(id, options)
  edit_admin_offer_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"offers",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_our_advantage => /our_advantages/:id/edit(.:format)
  // function(id, options)
  edit_admin_our_advantage_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"our_advantages",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_partner => /partners/:id/edit(.:format)
  // function(id, options)
  edit_admin_partner_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"partners",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_post => /posts/:id/edit(.:format)
  // function(id, options)
  edit_admin_post_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"posts",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_practice_basis => /practice_bases/:id/edit(.:format)
  // function(id, options)
  edit_admin_practice_basis_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"practice_bases",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_privacy_policy => /privacy_policy/:id/edit(.:format)
  // function(id, options)
  edit_admin_privacy_policy_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"privacy_policy",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_promo_code => /promo_codes/:id/edit(.:format)
  // function(id, options)
  edit_admin_promo_code_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"promo_codes",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_promotion => /promotions/:id/edit(.:format)
  // function(id, options)
  edit_admin_promotion_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"promotions",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_recall => /recalls/:id/edit(.:format)
  // function(id, options)
  edit_admin_recall_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"recalls",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_reward_image => /reward_images/:id/edit(.:format)
  // function(id, options)
  edit_admin_reward_image_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"reward_images",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_service => /services/:id/edit(.:format)
  // function(id, options)
  edit_admin_service_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"services",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_skill => /skills/:id/edit(.:format)
  // function(id, options)
  edit_admin_skill_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"skills",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_social_lookup => /social_lookups/:id/edit(.:format)
  // function(id, options)
  edit_admin_social_lookup_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"social_lookups",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_speciality => /specialities/:id/edit(.:format)
  // function(id, options)
  edit_admin_speciality_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"specialities",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_static_page => /static_pages/:id/edit(.:format)
  // function(id, options)
  edit_admin_static_page_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"static_pages",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_student => /students/:id/edit(.:format)
  // function(id, options)
  edit_admin_student_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_student_group_subscription => /students/:student_id/group_subscriptions/:id/edit(.:format)
  // function(student_id, id, options)
  edit_admin_student_group_subscription_path: Utils.route(["student_id","id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"student_id",false],[2,[7,"/",false],[2,[6,"group_subscriptions",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]]]], arguments),
// edit_admin_student_order => /students/:student_id/orders/:id/edit(.:format)
  // function(student_id, id, options)
  edit_admin_student_order_path: Utils.route(["student_id","id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"student_id",false],[2,[7,"/",false],[2,[6,"orders",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]]]], arguments),
// edit_admin_student_payment_log => /students/:student_id/payment_logs/:id/edit(.:format)
  // function(student_id, id, options)
  edit_admin_student_payment_log_path: Utils.route(["student_id","id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"student_id",false],[2,[7,"/",false],[2,[6,"payment_logs",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]]]], arguments),
// edit_admin_tour_image => /tour_images/:id/edit(.:format)
  // function(id, options)
  edit_admin_tour_image_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"tour_images",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_tutorial => /tutorial/edit(.:format)
  // function(options)
  edit_admin_tutorial_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"tutorial",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// edit_admin_uploaded_video => /uploaded_videos/:id/edit(.:format)
  // function(id, options)
  edit_admin_uploaded_video_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"uploaded_videos",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_used_time => /used_times/:id/edit(.:format)
  // function(id, options)
  edit_admin_used_time_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"used_times",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_vacancy_group => /vacancy_groups/:id/edit(.:format)
  // function(id, options)
  edit_admin_vacancy_group_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"vacancy_groups",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_verification_tutorial => /verification_tutorial/edit(.:format)
  // function(options)
  edit_admin_verification_tutorial_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"verification_tutorial",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// edit_admin_work => /works/:id/edit(.:format)
  // function(id, options)
  edit_admin_work_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"works",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_admin_work_result => /work_results/:id/edit(.:format)
  // function(id, options)
  edit_admin_work_result_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"work_results",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_courses_shop_group_subscription => /group_subscriptions/:id/edit(.:format)
  // function(id, options)
  edit_courses_shop_group_subscription_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"group_subscriptions",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_courses_shop_profile => /profile/edit(.:format)
  // function(options)
  edit_courses_shop_profile_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"profile",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// edit_courses_shop_user_password => /users/password/edit(.:format)
  // function(options)
  edit_courses_shop_user_password_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"password",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// edit_courses_shop_user_registration => /users/edit(.:format)
  // function(options)
  edit_courses_shop_user_registration_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// edit_profile => /profile/edit(.:format)
  // function(options)
  edit_profile_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"profile",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// edit_user_password => /users/password/edit(.:format)
  // function(options)
  edit_user_password_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"password",false],[2,[7,"/",false],[2,[6,"edit",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// en => /en(.:format)
  // function(options)
  en_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"en",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// expire_task_results => /tasks/:task_id/results/expire(.:format)
  // function(task_id, options)
  expire_task_results_path: Utils.route(["task_id"], ["format"], [2,[7,"/",false],[2,[6,"tasks",false],[2,[7,"/",false],[2,[3,"task_id",false],[2,[7,"/",false],[2,[6,"results",false],[2,[7,"/",false],[2,[6,"expire",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// failed_paykeepers => /paykeepers/failed(.:format)
  // function(options)
  failed_paykeepers_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"paykeepers",false],[2,[7,"/",false],[2,[6,"failed",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// feedback => /feedback(.:format)
  // function(options)
  feedback_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"feedback",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// feedback_message_sent => /feedback/message_sent(.:format)
  // function(options)
  feedback_message_sent_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"feedback",false],[2,[7,"/",false],[2,[6,"message_sent",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// feedback_question_files => /feedback_question_files(.:format)
  // function(options)
  feedback_question_files_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"feedback_question_files",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// feedback_questions => /feedback_questions(.:format)
  // function(options)
  feedback_questions_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"feedback_questions",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// feedbacks => /feedbacks(.:format)
  // function(options)
  feedbacks_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"feedbacks",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// funnel_generation_admin_courses => /courses/funnel_generation(.:format)
  // function(options)
  funnel_generation_admin_courses_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[6,"funnel_generation",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// generate_admin_student_subscription_documents => /students/:student_id/subscription_documents/generate(.:format)
  // function(student_id, options)
  generate_admin_student_subscription_documents_path: Utils.route(["student_id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"student_id",false],[2,[7,"/",false],[2,[6,"subscription_documents",false],[2,[7,"/",false],[2,[6,"generate",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// hide_tutorial => /tutorial/hide(.:format)
  // function(options)
  hide_tutorial_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"tutorial",false],[2,[7,"/",false],[2,[6,"hide",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// import_admin_students => /students/import(.:format)
  // function(options)
  import_admin_students_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[6,"import",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// info_admin_group => /groups/:id/info(.:format)
  // function(id, options)
  info_admin_group_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"info",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// lecture_material => /lectures/:lecture_id/materials/:id(.:format)
  // function(lecture_id, id, options)
  lecture_material_path: Utils.route(["lecture_id","id"], ["format"], [2,[7,"/",false],[2,[6,"lectures",false],[2,[7,"/",false],[2,[3,"lecture_id",false],[2,[7,"/",false],[2,[6,"materials",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// list_admin_advantages => /advantages/list(.:format)
  // function(options)
  list_admin_advantages_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"advantages",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// list_admin_articles => /articles/list(.:format)
  // function(options)
  list_admin_articles_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"articles",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// list_admin_blocks => /blocks/list(.:format)
  // function(options)
  list_admin_blocks_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"blocks",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// list_admin_courses => /courses/list(.:format)
  // function(options)
  list_admin_courses_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// list_admin_curriculum_blocks => /curriculum_blocks/list(.:format)
  // function(options)
  list_admin_curriculum_blocks_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"curriculum_blocks",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// list_admin_education_documents => /education_documents/list(.:format)
  // function(options)
  list_admin_education_documents_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"education_documents",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// list_admin_faculties => /faculties/list(.:format)
  // function(options)
  list_admin_faculties_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"faculties",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// list_admin_group_subscriptions => /group_subscriptions/list(.:format)
  // function(options)
  list_admin_group_subscriptions_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"group_subscriptions",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// list_admin_instructors => /instructors/list(.:format)
  // function(options)
  list_admin_instructors_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"instructors",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// list_admin_my_students => /my_students/list(.:format)
  // function(options)
  list_admin_my_students_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"my_students",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// list_admin_recalls => /recalls/list(.:format)
  // function(options)
  list_admin_recalls_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"recalls",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// list_admin_skills => /skills/list(.:format)
  // function(options)
  list_admin_skills_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"skills",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// list_admin_specialities => /specialities/list(.:format)
  // function(options)
  list_admin_specialities_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"specialities",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// list_admin_students => /students/list(.:format)
  // function(options)
  list_admin_students_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// list_admin_uploaded_videos => /uploaded_videos/list(.:format)
  // function(options)
  list_admin_uploaded_videos_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"uploaded_videos",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// list_api_group_prices => /api/group_prices/list(.:format)
  // function(options)
  list_api_group_prices_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"api",false],[2,[7,"/",false],[2,[6,"group_prices",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// list_api_group_subscription_info => /api/group_subscription_info/list(.:format)
  // function(options)
  list_api_group_subscription_info_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"api",false],[2,[7,"/",false],[2,[6,"group_subscription_info",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// list_api_student_info => /api/student_info/list(.:format)
  // function(options)
  list_api_student_info_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"api",false],[2,[7,"/",false],[2,[6,"student_info",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// list_used_times => /used_times/list(.:format)
  // function(options)
  list_used_times_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"used_times",false],[2,[7,"/",false],[2,[6,"list",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// load_api_document => /api/documents/:id/load(.:format)
  // function(id, options)
  load_api_document_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"api",false],[2,[7,"/",false],[2,[6,"documents",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"load",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// load_api_private_files => /api/private_files/load(.:format)
  // function(options)
  load_api_private_files_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"api",false],[2,[7,"/",false],[2,[6,"private_files",false],[2,[7,"/",false],[2,[6,"load",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// mark_as_finished_lecture_material => /lectures/:lecture_id/materials/:id/mark_as_finished(.:format)
  // function(lecture_id, id, options)
  mark_as_finished_lecture_material_path: Utils.route(["lecture_id","id"], ["format"], [2,[7,"/",false],[2,[6,"lectures",false],[2,[7,"/",false],[2,[3,"lecture_id",false],[2,[7,"/",false],[2,[6,"materials",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"mark_as_finished",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]]]], arguments),
// message_sent_feedbacks => /feedbacks/message_sent(.:format)
  // function(options)
  message_sent_feedbacks_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"feedbacks",false],[2,[7,"/",false],[2,[6,"message_sent",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_administrator => /administrators/new(.:format)
  // function(options)
  new_admin_administrator_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"administrators",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_advantage => /advantages/new(.:format)
  // function(options)
  new_admin_advantage_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"advantages",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_amo_module => /amo_modules/new(.:format)
  // function(options)
  new_admin_amo_module_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"amo_modules",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_article => /articles/new(.:format)
  // function(options)
  new_admin_article_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"articles",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_attendance_report => /attendance_report/new(.:format)
  // function(options)
  new_admin_attendance_report_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"attendance_report",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_automatic_discount => /automatic_discounts/new(.:format)
  // function(options)
  new_admin_automatic_discount_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"automatic_discounts",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_banner => /banners/new(.:format)
  // function(options)
  new_admin_banner_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"banners",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_block => /blocks/new(.:format)
  // function(options)
  new_admin_block_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"blocks",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_book => /books/new(.:format)
  // function(options)
  new_admin_book_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"books",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_campaign_index => /campaign_indices/new(.:format)
  // function(options)
  new_admin_campaign_index_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"campaign_indices",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_consultation => /consultations/new(.:format)
  // function(options)
  new_admin_consultation_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"consultations",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_contacts_merge => /contacts_merges/new(.:format)
  // function(options)
  new_admin_contacts_merge_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"contacts_merges",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_contingent => /contingents/new(.:format)
  // function(options)
  new_admin_contingent_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"contingents",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_course => /courses/new(.:format)
  // function(options)
  new_admin_course_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_course_notice => /courses/:course_id/notices/new(.:format)
  // function(course_id, options)
  new_admin_course_notice_path: Utils.route(["course_id"], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[3,"course_id",false],[2,[7,"/",false],[2,[6,"notices",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// new_admin_curriculum_block => /curriculum_blocks/new(.:format)
  // function(options)
  new_admin_curriculum_block_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"curriculum_blocks",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_debtor_report => /debtor_reports/new(.:format)
  // function(options)
  new_admin_debtor_report_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"debtor_reports",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_discount => /discounts/new(.:format)
  // function(options)
  new_admin_discount_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"discounts",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_document => /documents/new(.:format)
  // function(options)
  new_admin_document_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"documents",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_document_section => /document_sections/new(.:format)
  // function(options)
  new_admin_document_section_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"document_sections",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_education_level => /education_levels/new(.:format)
  // function(options)
  new_admin_education_level_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"education_levels",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_faculty => /faculties/new(.:format)
  // function(options)
  new_admin_faculty_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"faculties",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_faq => /faq/new(.:format)
  // function(options)
  new_admin_faq_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"faq",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_graduate => /graduates/new(.:format)
  // function(options)
  new_admin_graduate_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"graduates",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_group => /groups/new(.:format)
  // function(options)
  new_admin_group_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_group_attendance_report => /groups/:group_id/attendance_report/new(.:format)
  // function(group_id, options)
  new_admin_group_attendance_report_path: Utils.route(["group_id"], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[3,"group_id",false],[2,[7,"/",false],[2,[6,"attendance_report",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// new_admin_group_subscription_attendance_report => /group_subscriptions/:group_subscription_id/attendance_report/new(.:format)
  // function(group_subscription_id, options)
  new_admin_group_subscription_attendance_report_path: Utils.route(["group_subscription_id"], ["format"], [2,[7,"/",false],[2,[6,"group_subscriptions",false],[2,[7,"/",false],[2,[3,"group_subscription_id",false],[2,[7,"/",false],[2,[6,"attendance_report",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// new_admin_history_event => /history_events/new(.:format)
  // function(options)
  new_admin_history_event_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"history_events",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_instructor => /instructors/new(.:format)
  // function(options)
  new_admin_instructor_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"instructors",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_letter => /letters/new(.:format)
  // function(options)
  new_admin_letter_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"letters",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_magazine_payment_type => /magazine_payment_types/new(.:format)
  // function(options)
  new_admin_magazine_payment_type_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"magazine_payment_types",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_manager => /managers/new(.:format)
  // function(options)
  new_admin_manager_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"managers",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_partner => /partners/new(.:format)
  // function(options)
  new_admin_partner_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"partners",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_payment_statistic => /payment_statistics/new(.:format)
  // function(options)
  new_admin_payment_statistic_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"payment_statistics",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_payments_report => /payments_reports/new(.:format)
  // function(options)
  new_admin_payments_report_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"payments_reports",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_period_order => /period_orders/new(.:format)
  // function(options)
  new_admin_period_order_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"period_orders",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_post => /posts/new(.:format)
  // function(options)
  new_admin_post_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"posts",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_practice_basis => /practice_bases/new(.:format)
  // function(options)
  new_admin_practice_basis_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"practice_bases",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_promo_code => /promo_codes/new(.:format)
  // function(options)
  new_admin_promo_code_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"promo_codes",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_promotion => /promotions/new(.:format)
  // function(options)
  new_admin_promotion_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"promotions",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_recall => /recalls/new(.:format)
  // function(options)
  new_admin_recall_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"recalls",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_reward_image => /reward_images/new(.:format)
  // function(options)
  new_admin_reward_image_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"reward_images",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_service => /services/new(.:format)
  // function(options)
  new_admin_service_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"services",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_skill => /skills/new(.:format)
  // function(options)
  new_admin_skill_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"skills",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_static_page => /static_pages/new(.:format)
  // function(options)
  new_admin_static_page_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"static_pages",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_student => /students/new(.:format)
  // function(options)
  new_admin_student_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_student_group_subscription => /students/:student_id/group_subscriptions/new(.:format)
  // function(student_id, options)
  new_admin_student_group_subscription_path: Utils.route(["student_id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"student_id",false],[2,[7,"/",false],[2,[6,"group_subscriptions",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// new_admin_student_order => /students/:student_id/orders/new(.:format)
  // function(student_id, options)
  new_admin_student_order_path: Utils.route(["student_id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"student_id",false],[2,[7,"/",false],[2,[6,"orders",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// new_admin_student_payment_log => /students/:student_id/payment_logs/new(.:format)
  // function(student_id, options)
  new_admin_student_payment_log_path: Utils.route(["student_id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"student_id",false],[2,[7,"/",false],[2,[6,"payment_logs",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// new_admin_tour_image => /tour_images/new(.:format)
  // function(options)
  new_admin_tour_image_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"tour_images",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_uploaded_video => /uploaded_videos/new(.:format)
  // function(options)
  new_admin_uploaded_video_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"uploaded_videos",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_used_time => /used_times/new(.:format)
  // function(options)
  new_admin_used_time_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"used_times",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_vacancy_group => /vacancy_groups/new(.:format)
  // function(options)
  new_admin_vacancy_group_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"vacancy_groups",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_work => /works/new(.:format)
  // function(options)
  new_admin_work_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"works",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_admin_work_result => /work_results/new(.:format)
  // function(options)
  new_admin_work_result_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"work_results",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_courses_shop_group_subscription => /group_subscriptions/new(.:format)
  // function(options)
  new_courses_shop_group_subscription_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"group_subscriptions",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_courses_shop_order => /orders/new(.:format)
  // function(options)
  new_courses_shop_order_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"orders",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_courses_shop_user_password => /users/password/new(.:format)
  // function(options)
  new_courses_shop_user_password_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"password",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// new_courses_shop_user_registration => /users/sign_up(.:format)
  // function(options)
  new_courses_shop_user_registration_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"sign_up",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_courses_shop_user_session => /users/sign_in(.:format)
  // function(options)
  new_courses_shop_user_session_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"sign_in",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// new_user_password => /users/password/new(.:format)
  // function(options)
  new_user_password_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"password",false],[2,[7,"/",false],[2,[6,"new",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// new_user_session => /users/sign_in(.:format)
  // function(options)
  new_user_session_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"sign_in",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// notice => /notices/:id(.:format)
  // function(id, options)
  notice_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"notices",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// notify_admin_article => /articles/:id/notify(.:format)
  // function(id, options)
  notify_admin_article_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"articles",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"notify",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// notify_admin_result_comment => /results/:result_id/comment/notify(.:format)
  // function(result_id, options)
  notify_admin_result_comment_path: Utils.route(["result_id"], ["format"], [2,[7,"/",false],[2,[6,"results",false],[2,[7,"/",false],[2,[3,"result_id",false],[2,[7,"/",false],[2,[6,"comment",false],[2,[7,"/",false],[2,[6,"notify",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// pay_courses_shop_order => /orders/:id/pay(.:format)
  // function(id, options)
  pay_courses_shop_order_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"orders",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"pay",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// preview_courses => /courses/preview(.:format)
  // function(options)
  preview_courses_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[6,"preview",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// private_file => /private_file(.:format)
  // function(options)
  private_file_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"private_file",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// profile => /profile(.:format)
  // function(options)
  profile_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"profile",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// progress => /progress(.:format)
  // function(options)
  progress_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"progress",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// rails_info => /rails/info(.:format)
  // function(options)
  rails_info_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"rails",false],[2,[7,"/",false],[2,[6,"info",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// rails_info_properties => /rails/info/properties(.:format)
  // function(options)
  rails_info_properties_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"rails",false],[2,[7,"/",false],[2,[6,"info",false],[2,[7,"/",false],[2,[6,"properties",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// rails_info_routes => /rails/info/routes(.:format)
  // function(options)
  rails_info_routes_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"rails",false],[2,[7,"/",false],[2,[6,"info",false],[2,[7,"/",false],[2,[6,"routes",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// rails_mailers => /rails/mailers(.:format)
  // function(options)
  rails_mailers_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"rails",false],[2,[7,"/",false],[2,[6,"mailers",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// rating_course => /courses/:id/rating(.:format)
  // function(id, options)
  rating_course_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"courses",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"rating",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// really_destroy_admin_student_group_subscriptions => /students/:student_id/group_subscriptions/really_destroy(.:format)
  // function(student_id, options)
  really_destroy_admin_student_group_subscriptions_path: Utils.route(["student_id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"student_id",false],[2,[7,"/",false],[2,[6,"group_subscriptions",false],[2,[7,"/",false],[2,[6,"really_destroy",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// recalculate_admin_student_payments => /students/:student_id/payments/recalculate(.:format)
  // function(student_id, options)
  recalculate_admin_student_payments_path: Utils.route(["student_id"], ["format"], [2,[7,"/",false],[2,[6,"students",false],[2,[7,"/",false],[2,[3,"student_id",false],[2,[7,"/",false],[2,[6,"payments",false],[2,[7,"/",false],[2,[6,"recalculate",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// refunds_admin_group_expulsion_order => /groups/:group_id/expulsion_order/refunds(.:format)
  // function(group_id, options)
  refunds_admin_group_expulsion_order_path: Utils.route(["group_id"], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[3,"group_id",false],[2,[7,"/",false],[2,[6,"expulsion_order",false],[2,[7,"/",false],[2,[6,"refunds",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// reply_admin_letter => /letters/:id/reply(.:format)
  // function(id, options)
  reply_admin_letter_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"letters",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"reply",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// report_admin_my_student => /my_students/:id/report(.:format)
  // function(id, options)
  report_admin_my_student_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"my_students",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"report",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// result_paykeepers => /paykeepers/result(.:format)
  // function(options)
  result_paykeepers_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"paykeepers",false],[2,[7,"/",false],[2,[6,"result",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// root => /
  // function(options)
  root_path: Utils.route([], [], [7,"/",false], arguments),
// run_admin_amocrm_import => /amocrm_import/run(.:format)
  // function(options)
  run_admin_amocrm_import_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"amocrm_import",false],[2,[7,"/",false],[2,[6,"run",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// search_admin_groups => /groups/search(.:format)
  // function(options)
  search_admin_groups_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"groups",false],[2,[7,"/",false],[2,[6,"search",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// send_contract_admin_group_subscription_contract => /group_subscriptions/:group_subscription_id/contract/send_contract(.:format)
  // function(group_subscription_id, options)
  send_contract_admin_group_subscription_contract_path: Utils.route(["group_subscription_id"], ["format"], [2,[7,"/",false],[2,[6,"group_subscriptions",false],[2,[7,"/",false],[2,[3,"group_subscription_id",false],[2,[7,"/",false],[2,[6,"contract",false],[2,[7,"/",false],[2,[6,"send_contract",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// send_contract_admin_order_contract => /orders/:order_id/contract/send_contract(.:format)
  // function(order_id, options)
  send_contract_admin_order_contract_path: Utils.route(["order_id"], ["format"], [2,[7,"/",false],[2,[6,"orders",false],[2,[7,"/",false],[2,[3,"order_id",false],[2,[7,"/",false],[2,[6,"contract",false],[2,[7,"/",false],[2,[6,"send_contract",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// send_form_data_courses_shop_callbacks => /callbacks/send_form_data(.:format)
  // function(options)
  send_form_data_courses_shop_callbacks_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"callbacks",false],[2,[7,"/",false],[2,[6,"send_form_data",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// sort_admin_history_events => /history_events/sort(.:format)
  // function(options)
  sort_admin_history_events_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"history_events",false],[2,[7,"/",false],[2,[6,"sort",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// static_page => /:id(.:format)
  // function(id, options)
  static_page_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// subscribe_courses_shop_unisender_index => /unisender/subscribe(.:format)
  // function(options)
  subscribe_courses_shop_unisender_index_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"unisender",false],[2,[7,"/",false],[2,[6,"subscribe",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// success_paykeepers => /paykeepers/success(.:format)
  // function(options)
  success_paykeepers_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"paykeepers",false],[2,[7,"/",false],[2,[6,"success",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// surveymonkey_response_completed => /surveymonkey/response_completed(.:format)
  // function(options)
  surveymonkey_response_completed_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"surveymonkey",false],[2,[7,"/",false],[2,[6,"response_completed",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// task_files => /tasks/:task_id/files(.:format)
  // function(task_id, options)
  task_files_path: Utils.route(["task_id"], ["format"], [2,[7,"/",false],[2,[6,"tasks",false],[2,[7,"/",false],[2,[3,"task_id",false],[2,[7,"/",false],[2,[6,"files",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// task_results => /tasks/:task_id/results(.:format)
  // function(task_id, options)
  task_results_path: Utils.route(["task_id"], ["format"], [2,[7,"/",false],[2,[6,"tasks",false],[2,[7,"/",false],[2,[3,"task_id",false],[2,[7,"/",false],[2,[6,"results",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// toggle_field_admin_article => /articles/:id/toggle_field(.:format)
  // function(id, options)
  toggle_field_admin_article_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"articles",false],[2,[7,"/",false],[2,[3,"id",false],[2,[7,"/",false],[2,[6,"toggle_field",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// tutorial => /tutorial(.:format)
  // function(options)
  tutorial_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"tutorial",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// unsubscribe_subscription_notifications => /subscription_notifications/unsubscribe(.:format)
  // function(options)
  unsubscribe_subscription_notifications_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"subscription_notifications",false],[2,[7,"/",false],[2,[6,"unsubscribe",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// user_activities => /user_activities(.:format)
  // function(options)
  user_activities_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"user_activities",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// user_authentication => /users/authentications/:id(.:format)
  // function(id, options)
  user_authentication_path: Utils.route(["id"], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"authentications",false],[2,[7,"/",false],[2,[3,"id",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// user_omniauth_authorize => /users/auth/:provider(.:format)
  // function(provider, options)
  user_omniauth_authorize_path: Utils.route(["provider"], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"auth",false],[2,[7,"/",false],[2,[3,"provider",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments),
// user_omniauth_callback => /users/auth/:action/callback(.:format)
  // function(action, options)
  user_omniauth_callback_path: Utils.route(["action"], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"auth",false],[2,[7,"/",false],[2,[3,"action",false],[2,[7,"/",false],[2,[6,"callback",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]]]], arguments),
// user_password => /users/password(.:format)
  // function(options)
  user_password_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"password",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// user_session => /users/sign_in(.:format)
  // function(options)
  user_session_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"users",false],[2,[7,"/",false],[2,[6,"sign_in",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]], arguments),
// vacancies => /vacancies(.:format)
  // function(options)
  vacancies_path: Utils.route([], ["format"], [2,[7,"/",false],[2,[6,"vacancies",false],[1,[2,[8,".",false],[3,"format",false]],false]]], arguments),
// vacancy_show_content => /vacancies/:vacancy_id/show_content(.:format)
  // function(vacancy_id, options)
  vacancy_show_content_path: Utils.route(["vacancy_id"], ["format"], [2,[7,"/",false],[2,[6,"vacancies",false],[2,[7,"/",false],[2,[3,"vacancy_id",false],[2,[7,"/",false],[2,[6,"show_content",false],[1,[2,[8,".",false],[3,"format",false]],false]]]]]]], arguments)}
;
    root.Routes.options = defaults;
    return root.Routes;
  };

  if (typeof define === "function" && define.amd) {
    define([], function() {
      return createGlobalJsRoutesObject();
    });
  } else {
    createGlobalJsRoutesObject();
  }

}).call(this);

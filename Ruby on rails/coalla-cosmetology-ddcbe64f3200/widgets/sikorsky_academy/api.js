define(['jquery'], function($){

    var API = function(widget) {
        this.widget = widget;
    };

    API.prototype.query = function(method, params, successCallback) {
        var params = $.extend(params, {token: this.widget.get_settings().api_key});
        this.widget.crm_post(this.widget.get_settings().api_host + method, params, successCallback, 'json')
    };

    return API;
});

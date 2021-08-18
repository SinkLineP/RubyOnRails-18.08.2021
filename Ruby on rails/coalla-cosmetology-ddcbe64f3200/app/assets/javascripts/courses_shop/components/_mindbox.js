var MindboxWrapper = function () {
    function async(params, callback) {
        params['onSuccess'] = callback;
        params['onError'] = callback;
        mindbox('async', params);
    }

    function identify(params, callback) {
        params['success'] = callback;
        params['error'] = callback;
        mindbox('identify', params);
    }

    this.operation = function (data, callback) {
        console.log({mindbox: data});

        if (window['mindbox']) {
            var operationName = data[0],
                params = data[1];

            if (operationName === 'async') {
                async(params, callback);
            } else if (operationName === 'identify') {
                identify(params, callback);
            }

            return;
        }

        if (typeof callback !== 'undefined' && callback) {
            callback();
        }
    };

    return this;
};

var mindboxWrapper = new MindboxWrapper();
var wkbridge = {
    __callbacks: {},
    invokeCallback: function(cbID, removeAfterExecute) {
        var args = Array.prototype.slice.call(arguments);
        args.shift();
        args.shift();
        for (var i = 0, l = args.length; i < l; i++) {
            args[i] = decodeURIComponent(args[i]);
        }
        var cb = wkbridge.__callbacks[cbID];
        if (removeAfterExecute) {
            wkbridge.__callbacks[cbID] = undefined;
        }
        if (undefined !== cb) return cb.apply(null, args);
    },
    call: function(namespace, method, args) {
		var e = ""
		var a = [];
		for (var i = 0, l = args.length; i < l; i++){
			if ("function" === typeof args[i]){
				var cbID = "__cb" + (+new Date);
				wkbridge.__callbacks[cbID] = args[i];
				a.push({id:cbID})
			}else{
				a.push(encodeURIComponent(args[i]));
			}
		}
        e = prompt("_wkbridge-js:" + namespace,JSON.stringify({func:method,args:a}))
        if (null !== e){
            return JSON.parse(e).result
        }
    },
    inject: function(namespace, methods) {
        window[namespace] = {};
        var jsObj = window[namespace];
        for (var i = 0, l = methods.length; i < l; i++) {
            (function() {
                var method = methods[i];
				var jsMethod = method.replace(new RegExp(":", "g"), "");
                jsObj[jsMethod] = function() {
					var args = Array.prototype.slice.call(arguments);
					var realMethod = jsMethod;
					for (var i = 0; i < args.length; i++) {
						realMethod = realMethod + ":"
					}
                    return wkbridge.call(namespace, realMethod, args);
                };
            })();
        }
    }
};
var wkbridge = {
    __callbacks: {},
    invokeCallback: function(id,rm) {
        var args = Array.prototype.slice.call(arguments);
        args.shift();
        args.shift();
        args = args.map(function(a){return decodeURIComponent(a)})
        var cb = wkbridge.__callbacks[id];
        if (rm&&undefined !== cb) { delete wkbridge.__callbacks[id] }
        if (undefined !== cb) return cb.apply(null, args);
    },
    call: function(n,m,a) {
        var f = function(v){
            if ("function" == typeof v){
                var i = "__cb" + (+new Date);
                wkbridge.__callbacks[i]=v;
                return {id:i};
            }else{ return encodeURIComponent(v);}
        }
        var r = prompt("_wkbridge-js:" + n,JSON.stringify({func:m,args:a.map(f)}))
        if (null !== r) return JSON.parse(r).result
    },
    inject: function(n, ms) {
        window[n]={};
        var jms = window[n];
        ms.forEach(function(om){
            var jm = om.replace(new RegExp(":", "g"), "");
            jms[jm] = function(){
                var args = Array.prototype.slice.call(arguments);
                var rm = jm + (args.length > 0 ? args.map(function(){return ":"}).reduce(function(x,y){return x + y}).toString():"")
                return wkbridge.call(n, rm, args);
            }
        })
    }
};
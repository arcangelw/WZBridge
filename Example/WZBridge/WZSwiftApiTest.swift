//
//  WZSwiftApiTest.swift
//  WZBridge_Example
//
//  Created by 吴哲 on 2018/12/12.
//  Copyright © 2018 arcangelw. All rights reserved.
//

import UIKit

@objc protocol WZSwiftApiTestExport:WZJSExport {
    func callSyn();
    func callSyn(_ msg:String) -> String;
    func callAsyn(_ msg:String,_ fun:WJSCallFunction)
    func callAsyn(_ fun:WJSCallFunction)
    @objc optional func callProgress(_ fun:WJSCallFunction)
}
class WZSwiftApiTest: NSObject ,WZSwiftApiTestExport{
    
    var _fun:WJSCallFunction?
    var _timer:Timer?
    var _t:Int = 10
    
    
    @objc func callSyn() {
        print(#function, " Hello, I am js")
    }
    
    @objc func callSyn(_ msg: String) -> String {
        print(#function, " Hello, I am js")
        return "hellow js ,I am Swift ,I received your message:\(msg)"
    }
    
    @objc func callAsyn(_ msg: String, _ fun: WJSCallFunction) {
        print(#function, " Hello, I am js")
        fun.execute(withParam: "hellow js ,I am Swift ,I received your message:\(msg)") { (result,_) in
            print(result ?? "")
        }
    }
    
    @objc func callAsyn(_ fun: WJSCallFunction) {
        print(#function, " Hello, I am js")
        fun.execute(withParam: "hellow js ,I am Swift ,I received your message") { (result,_) in
            print(result ?? "")
        }
    }
    @objc func callProgress(_ fun: WJSCallFunction) {
        if _fun != nil {
            _timer?.invalidate()
            _timer = nil;
            _fun?.removeAfterExecute = true
            _fun?.execute(withParam: "0", completionHandler: nil)
        }
        _fun = fun
        _fun?.removeAfterExecute = false
        _t = 10;
        _fun?.execute(withParam: "\(_t)")
        _timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(WZSwiftApiTest.onTimer(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func onTimer(_ t:Timer) {
        _t -= 1
        print("\(_t)")
        if _t > 0 {
            _fun?.execute(withParam: "\(_t)")
        }else{
            _fun?.removeAfterExecute = true
            _fun?.execute(withParam: "0")
            _timer?.invalidate()
            _timer = nil
        }
    }
}

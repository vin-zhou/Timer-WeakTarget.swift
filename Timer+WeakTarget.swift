//
//  NSTimer+WeakTarget.swift
//  VinZhou
//

import Foundation


// MARK: weak target
private class TargetWrapper{
    weak var target: AnyObject?
    var block: ()->Void
    
    init(_ target: AnyObject?, _ block: @escaping ()->Void) {
        self.target = target
        self.block = block
    }
    
    @objc func execute(_ timer: Timer) {
        if target == nil {
            timer.invalidate()
        } else {
            block()
        }
    }
    
    deinit {
        mp_print("TargetWrapper deinit")
    }
}

extension Timer {
    
    static func weakTarget_scheduledTimerWithTimeInterval(_ target: AnyObject, _ ti: TimeInterval, block: @escaping ()->(), repeats: Bool) -> Timer {
        let wrapper = TargetWrapper(target, block)
        return self.scheduledTimer(timeInterval: ti, target: wrapper, selector: #selector(TargetWrapper.execute(_:)), userInfo: nil, repeats: repeats)
    }
}

import Foundation

let worker = DispatchQueue(label: "worker")
let delegateQueue = DispatchQueue(label: "delegateQueue")

class AmpDelegateCallback {
    func callback() {}
}

class Test {
    weak var managerCallback: AmpDelegateCallback?

    func setCallback(_ callback: AmpDelegateCallback) {
        worker.async {
            self.managerCallback = callback
        }
    }

    func callCallback() {
        guard let manager = self.managerCallback else {
            return
        }

        delegateQueue.async {
            manager.callback()
        }
    }
}

var callback: AmpDelegateCallback!
let t = Test()
for i in 0 ..< 10000 {
    callback = AmpDelegateCallback()
    t.setCallback(callback)
    // callCalback is dispatched on worker queue!
    worker.async {
      t.callCallback()
    }
}

RunLoop.main.run(until: Date(timeIntervalSinceNow: 15))

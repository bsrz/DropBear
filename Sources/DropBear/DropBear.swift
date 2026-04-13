import Foundation
import os

public enum DropBear {
    public static let defaultWaitTime: TimeInterval = 5

    @MainActor
    public static func poll(until predicate: @escaping @MainActor @Sendable () -> Bool, timeout: TimeInterval) {
        let fulfilled = OSAllocatedUnfairLock(initialState: false)

        let timer = DispatchSource.makeTimerSource(flags: [.strict], queue: DispatchQueue.global(qos: .userInitiated))
        timer.schedule(deadline: .distantFuture, repeating: .milliseconds(5), leeway: .milliseconds(5))
        timer.setEventHandler(handler: { })

        let observer = CFRunLoopObserverCreateWithHandler(nil, CFRunLoopActivity.allActivities.rawValue, true, 0) { _, _ in
            let result = MainActor.assumeIsolated { predicate() }
            fulfilled.withLock { $0 = result }
            if result { CFRunLoopStop(CFRunLoopGetCurrent()) }
        }
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, .defaultMode)
        timer.resume()
        CFRunLoopRunInMode(.defaultMode, timeout, false)
        CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), observer, .defaultMode)

        timer.cancel()
    }
}


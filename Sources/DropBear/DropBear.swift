import Foundation

public enum DropBear {
    public static let defaultWaitTime: TimeInterval = 5

    @MainActor
    public static func poll(until predicate: @escaping @MainActor @Sendable () -> Bool, timeout: TimeInterval) {
        let deadline = Date(timeIntervalSinceNow: timeout)
        while !predicate() && Date() < deadline {
            CFRunLoopRunInMode(.defaultMode, 0.005, true)
        }
    }
}


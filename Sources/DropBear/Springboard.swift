@preconcurrency import XCTest

extension Springboard.DeleteAppButton {
    public static var `default`: Springboard.DeleteAppButton {
        Springboard.DeleteAppButton { app, icon in
            iOS26.delete(app, icon) || iOS18.delete(app, icon)
        }
    }

    public static var iOS17: Springboard.DeleteAppButton {
        return .init { application, icon in
            icon.press(forDuration: 1.0)

            let removeButton = application.buttons["Remove App"]
            guard removeButton.waitForExistence(timeout: DropBear.defaultWaitTime) && removeButton.isHittable else { return false }
            removeButton.tap()

            let deleteAppButton = application.alerts.buttons["Delete App"]
            guard deleteAppButton.waitForExistence(timeout: DropBear.defaultWaitTime) && deleteAppButton.isHittable else { return false }
            deleteAppButton.tap()

            let confirmButton = application.alerts.buttons["Delete"]
            guard confirmButton.waitForExistence(timeout: DropBear.defaultWaitTime) && confirmButton.isHittable else { return false }
            confirmButton.tap()

            return true
        }
    }

    public static var iOS18: Springboard.DeleteAppButton { iOS17 }

    public static var iOS26: Springboard.DeleteAppButton {
        return .init { application, icon in
            icon.press(forDuration: 1.5)

            let removeButton = application.buttons["Remove App"].firstMatch
            guard removeButton.waitForExistence(timeout: DropBear.defaultWaitTime) && removeButton.isHittable else { return false }
            removeButton.tap()

            let deleteAppButton = application.buttons["Delete App"].firstMatch
            guard deleteAppButton.waitForExistence(timeout: DropBear.defaultWaitTime) && deleteAppButton.isHittable else { return false }
            deleteAppButton.tap()

            let confirmButton = application.buttons["Delete"].firstMatch
            guard confirmButton.waitForExistence(timeout: DropBear.defaultWaitTime) && confirmButton.isHittable else { return false }
            confirmButton.tap()

            return true
        }
    }
}

@MainActor
public enum Springboard {
    static let application = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    public static func deleteApp(named name: String, using strategy: DeleteAppButton = .default, required: Bool = false, file: StaticString = #filePath, line: UInt = #line) {
        let icon = application.icons[name]
        let iconAvailable = icon.waitForExistence(timeout: DropBear.defaultWaitTime) && icon.isHittable

        // Icon isn't there, but we don't need it to be.
        if !required && !iconAvailable { return }

        guard iconAvailable else {
            return XCTFail("Application icon named '\(name)' not found.", file: file, line: line)
        }

        guard strategy.delete(application, icon) else {
            return XCTFail("Failed to delete the app.", file: file, line: line)
        }

        XCUIDevice.shared.press(.home)
    }
}

extension Springboard {
    public struct DeleteAppButton: @unchecked Sendable {
        public typealias Input = @MainActor @Sendable (_ application: XCUIApplication, _ icon: XCUIElement) -> Bool

        let delete: Input

        public init(delete: @escaping Input) {
            self.delete = delete
        }
    }
}

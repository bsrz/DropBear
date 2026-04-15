@preconcurrency import XCTest

public struct ContextElement<Context: RobotContext>: @unchecked Sendable {
    let element: @MainActor @Sendable (XCUIElement) -> XCUIElement

    public init(element: @escaping @MainActor @Sendable (XCUIElement) -> XCUIElement) {
        self.element = element
    }
}

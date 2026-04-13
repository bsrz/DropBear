@preconcurrency import XCTest

public struct Alert<Button: AlertButton> {
    public typealias Source = (_ current: XCUIElement) -> XCUIElement
    public typealias Dialog = (_ source: XCUIElement) -> XCUIElement

    public let source: Source
    public let dialog: Dialog
    public let assertion: ElementAssertion

    public init(source: @escaping Source, assertion: ElementAssertion) {
        self.source = source
        self.dialog = { $0.alerts.firstMatch }
        self.assertion = assertion
    }

    public init(source: @escaping Source, dialog: @escaping Dialog, assertion: ElementAssertion) {
        self.source = source
        self.dialog = dialog
        self.assertion = assertion
    }
}

public protocol AlertType {
    associatedtype AlertButtonType: AlertButton

    var assertion: ElementAssertion { get }
}

extension Alert: AlertType {
    public typealias AlertButtonType = Button
}

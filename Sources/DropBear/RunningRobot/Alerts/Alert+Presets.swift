@preconcurrency import XCTest

public enum ContactAlertButton: String, AlertButton {
    case dontAllow = "Don’t Allow"
    case `continue` = "Continue"
}

public enum ContactSharingButton: String, AlertButton {
    case selectContacts = "Select Contacts"
    case shareAll = "Share All"

    public func buttonElement(from alert: XCUIElement) -> XCUIElement {
        switch self {
        case .selectContacts:
            return alert.buttons[rawValue]
        case .shareAll:
            let predicate = NSPredicate(format: "label BEGINSWITH %@", "Share All")
            return alert.buttons.matching(predicate).firstMatch
        }
    }
}

extension Alert {
    @MainActor
    public static var contactsPermission: Alert<ContactAlertButton> {
        return .init(
            source: { _ in Springboard.application },
            assertion: .contains("Would Like to Access Your Contacts")
        )
    }

    @MainActor
    public static var contactsSharing: Alert<ContactSharingButton> {
        let limitedAccessPrompt = XCUIApplication(bundleIdentifier: "com.apple.ContactsUI.LimitedAccessPromptView")
        return .init(
            source: { _ in limitedAccessPrompt },
            dialog: { $0 },
            assertion: .contains("How do you want to share contacts")
        )
    }
}

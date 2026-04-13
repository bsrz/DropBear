public enum ContactAlertButton: String, AlertButton {
    case ok = "OK"
    case dontAllow = "Don’t Allow"
}

extension Alert {
    @MainActor
    public static var contactsPermission: Alert<ContactAlertButton> {
        return .init(
            source: { _ in Springboard.application },
            assertion: .contains("would like to access your contacts")
        )
    }
}

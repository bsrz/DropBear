import Testing
@testable import DropBear

@Suite("Context types")
struct ContextTypeTests {

    @Test("NoContext is Sendable")
    func noContextSendable() {
        let context = NoContext()
        let _: any Sendable = context
        // Compiles = passes. NoContext conforms to Sendable via RobotContext.
    }

    @Test("NoConfiguration is Sendable")
    func noConfigurationSendable() {
        let config = NoConfiguration()
        let _: any Sendable = config
    }
}

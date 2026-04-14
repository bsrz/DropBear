import Testing
@testable import DropBear

@Suite("UITestEquatable")
struct UITestEquatableTests {

    @Test("Bool true stringValues")
    func boolTrue() {
        #expect(true.stringValues == ["1"])
    }

    @Test("Bool false stringValues")
    func boolFalse() {
        #expect(false.stringValues == ["0"])
    }

    @Test("Int stringValues")
    func intValue() {
        #expect(42.stringValues == ["42"])
    }

    @Test("String stringValues")
    func stringValue() {
        #expect("hello".stringValues == ["hello"])
    }

    @Test("Double stringValues")
    func doubleValue() {
        #expect(3.14.stringValues == ["3.14"])
    }
}

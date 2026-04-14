import Testing
@testable import DropBear

@Suite("ElementAssertion Operators")
struct ElementAssertionOperatorTests {

    @Test("Negation operator flips result")
    func negation() {
        let trueAssertion = ElementAssertion(name: "true") { _ in true }
        let negated = !trueAssertion
        #expect(negated.name == "!true")
    }

    @Test("AND operator combines names")
    func andOperator() {
        let a = ElementAssertion(name: "a") { _ in true }
        let b = ElementAssertion(name: "b") { _ in false }
        let combined = a && b
        #expect(combined.name == "(a && b)")
    }

    @Test("OR operator combines names")
    func orOperator() {
        let a = ElementAssertion(name: "a") { _ in true }
        let b = ElementAssertion(name: "b") { _ in false }
        let combined = a || b
        #expect(combined.name == "(a || b)")
    }

    @Test("ElementAssertion stores name and message")
    func initProperties() {
        let assertion = ElementAssertion(name: "test", message: "failure message") { _ in true }
        #expect(assertion.name == "test")
        #expect(assertion.message == "failure message")
    }

    @Test("ElementAssertion message defaults to nil")
    func defaultMessage() {
        let assertion = ElementAssertion(name: "test") { _ in true }
        #expect(assertion.message == nil)
    }
}

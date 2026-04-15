import Testing
@testable import DropBear

@Suite("StringElement")
struct StringElementTests {

    @Test("Init from raw value")
    func rawValue() {
        let element = StringElement(rawValue: "myButton")
        #expect(element.rawValue == "myButton")
    }

    @Test("Init from string literal")
    func stringLiteral() {
        let element: StringElement = "myLabel"
        #expect(element.rawValue == "myLabel")
    }
}

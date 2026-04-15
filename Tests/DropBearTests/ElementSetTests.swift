import Testing
@testable import DropBear

@Suite("ElementSet")
struct ElementSetTests {

    enum ScreenA: String { case title, subtitle }
    enum ScreenB: String { case button, label }

    @Test("Init from raw value")
    func rawValue() {
        let set = ElementSet1<ScreenA>(rawValue: "title")
        #expect(set.rawValue == "title")
    }

    @Test("element() converts sub-element")
    func elementConversion() {
        let set: ElementSet1<ScreenA> = .element(ScreenA.title)
        #expect(set.rawValue == "title")
    }

    @Test("element() converts across different element types")
    func crossTypeConversion() {
        let set: ElementSet2<ScreenA, ScreenB> = .element(ScreenB.button)
        #expect(set.rawValue == "button")
    }
}

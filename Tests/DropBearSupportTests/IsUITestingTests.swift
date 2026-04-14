import Testing
@testable import DropBearSupport

@Suite("isUITesting")
struct IsUITestingTests {

    @Test("Returns false when env var not set")
    func notSet() {
        // In test environment, UITesting env var should not be set
        #expect(!isUITesting)
    }
}

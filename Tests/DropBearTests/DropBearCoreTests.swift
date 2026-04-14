import Testing
@testable import DropBear

@Suite("DropBear")
struct DropBearCoreTests {

    @Test("Default wait time is 5 seconds")
    func defaultWaitTime() {
        #expect(DropBear.defaultWaitTime == 5)
    }
}

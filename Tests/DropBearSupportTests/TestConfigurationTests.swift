import Foundation
import Testing
@testable import DropBearSupport

@Suite("TestConfiguration")
struct TestConfigurationTests {

    struct SampleConfig: Codable, Equatable {
        let name: String
        let count: Int
    }

    @Test("Decodes configuration from JSON file")
    func decodesFromFile() throws {
        let dir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: dir) }

        let sample = SampleConfig(name: "test", count: 42)
        let data = try JSONEncoder().encode(sample)
        try data.write(to: dir.appendingPathComponent("configuration.json"))

        let config = try TestConfiguration<SampleConfig>(in: dir)
        #expect(config.config == sample)
        #expect(config.temporaryPath == dir)
    }

    @Test("Dynamic member lookup forwards to config")
    func dynamicMemberLookup() throws {
        let dir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: dir) }

        let sample = SampleConfig(name: "hello", count: 7)
        try JSONEncoder().encode(sample).write(to: dir.appendingPathComponent("configuration.json"))

        let config = try TestConfiguration<SampleConfig>(in: dir)
        #expect(config.name == "hello")
        #expect(config.count == 7)
    }

    @Test("Throws when configuration file missing")
    func throwsOnMissingFile() {
        let dir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        #expect(throws: (any Error).self) {
            _ = try TestConfiguration<SampleConfig>(in: dir)
        }
    }

    @Test("Throws when JSON is malformed")
    func throwsOnBadJSON() throws {
        let dir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: dir) }

        try Data("not json".utf8).write(to: dir.appendingPathComponent("configuration.json"))

        #expect(throws: (any Error).self) {
            _ = try TestConfiguration<SampleConfig>(in: dir)
        }
    }
}

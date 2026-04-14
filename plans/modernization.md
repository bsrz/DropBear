# DropBear Modernization Plan

## Current State

DropBear — iOS UI testing framework using Robot pattern. Well-designed, good separation of concerns. Frozen in Swift 5.3 / iOS 10 era.

### Key Issues

| Area | Problem |
|------|---------|
| Swift tools version | 5.3 — need 6.0 |
| Platform | iOS 10 minimum — ancient |
| Concurrency | Zero Swift Concurrency. CFRunLoop + DispatchSource polling |
| Sendable | No `Sendable` conformances anywhere |
| Strict concurrency | Will break hard under Swift 6 strict checking |
| DropBearGen | SwiftSyntax 0.50600.1 — ancient. Current = 600.x |
| CocoaPods | Podspecs still maintained. SPM only path forward |
| Springboard | iOS 12-15 strategies. No iOS 16/17/18 |
| Tests | Effectively zero unit tests |
| Force-try | `try!` in `XCUIApplication+Configuration.swift` |
| ElementSet | Arity-10 generic workaround — Swift 6 parameter packs replace this |

---

## Phase 1: Swift 6 + Strict Concurrency (highest priority)

- [ ] Bump `swift-tools-version:6.0`
- [ ] Bump platform to `.iOS(.v16)` minimum
- [ ] Add `Sendable` to all value types: `StringElement`, `ElementAssertion`, `NoContext`, `NoConfiguration`, `DeleteAppButton`
- [ ] Mark `Robot` protocol as `@MainActor` — XCUIElement API is main-actor-bound
- [ ] `ElementAssertion` closure needs `@Sendable` annotation
- [ ] Fix `DropBear.poll()` data race — mutable `fulfilled` var captured across threads. Use `Mutex` or `Atomic`
- [ ] Add `@preconcurrency import XCTest` if XCTest not fully annotated yet
- [ ] Add `nonisolated(unsafe)` or proper isolation for `Springboard.application` static property

## Phase 2: Replace ElementSet with Parameter Packs

- [ ] Replace 10-arity `ElementSet` generic with parameter packs (Swift 5.9+)
- [ ] Remove `Unused` sentinel type
- [ ] Remove `ElementSet1` through `ElementSet10` typealiases
- [ ] Remove `_ElementSet` protocol and its 10 `element()` overloads
- [ ] Update all call sites

```swift
// Before: 10 generic params + Unused sentinel
public struct ElementSet<A, B, C, D, E, F, G, H, I, J>

// After: parameter packs
public struct ElementSet<each T: RawRepresentable> where repeat (each T).RawValue == String
```

## Phase 3: Modernize Polling

- [x] Replace CFRunLoop + DispatchSource in `DropBear.poll()` with modern approach
- [x] Consider async/await version (caveat: XCTest UI testing runs synchronously on main thread — kept sync with simplified run loop spin)
- [x] Replace `Thread.sleep()` in `Robot.wait()` with run loop spin (async not viable — `@MainActor` sync context)

## Phase 4: Update Springboard for Modern iOS

- [x] Drop iOS 12/13 strategies (minimum now iOS 16)
- [x] Add iOS 16/17/18 delete strategies
- [x] Fix bug: `Springboard.swift:48` checks `button.waitForExistence` instead of `deleteButton.waitForExistence`

## Phase 5: Modernize DropBearGen

- [x] Update SwiftSyntax `0.50600.1` → `600.0.1` (API completely different)
- [x] Drop `lib_InternalSwiftSyntaxParser` binary framework — no longer needed
- [ ] Consider converting to Swift Package Plugin instead of standalone CLI

## Phase 6: Drop CocoaPods

- [x] Remove `DropBear.podspec`
- [x] Remove `DropBearGen.podspec`
- [x] Remove `DropBearSupport.podspec`
- [x] SPM as sole distribution method

## Phase 7: Misc Cleanup

- [x] `try!` → proper error handling or `do/catch` with `XCTFail` in `XCUIApplication+Configuration.swift`
- [x] `RunningRobot.init(source:)` — improved fatalError message (`@available(*, unavailable)` not viable: breaks `Robot` protocol conformance)
- [x] `try!` → proper error handling in `DropBearSupport/TestConfiguration`
- [x] Add actual unit tests for core types (23 tests across DropBearTests + DropBearSupportTests)

---

## Execution Order

Phases 1-4 can proceed somewhat independently, but recommended order:

1. **Phase 1** — Foundation. Everything else depends on Swift 6 compilation.
2. **Phase 2** — Parameter packs. Clean win, reduces code.
3. **Phase 3** — Polling modernization.
4. **Phase 4** — Springboard update (includes bugfix).
5. **Phase 5** — DropBearGen (biggest effort — SwiftSyntax API migration).
6. **Phase 6** — Drop CocoaPods.
7. **Phase 7** — Final cleanup + tests.

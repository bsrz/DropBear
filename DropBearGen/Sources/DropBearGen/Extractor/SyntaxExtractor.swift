import SwiftSyntax
import SwiftParser

public final class SyntaxExtractor: Extractor {
    // MARK: - Lifecycle
    public init() { }

    // MARK: - Public Functions
    public func accessibilityIdentifierPairs(for file: Path) throws -> [AccessibilityIdentifierPair] {
        guard file.extension == "swift" else { return [] }

        let visitor = Visitor()
        let source = try String(contentsOf: file.url, encoding: .utf8)
        let syntax = Parser.parse(source: source)
        visitor.walk(syntax)
        return visitor.pairs
    }
}

private class Visitor: SyntaxVisitor {
    var pairs: [AccessibilityIdentifierPair] = []

    init() {
        super.init(viewMode: .sourceAccurate)
    }

    override func visitPost(_ node: MemberAccessExprSyntax) {
        guard
            node.declName.baseName.text == "accessibilityIdentifier",
            let pair = extractUIKit(node) ?? extractSwiftUI(node)
            else { return }

        pairs.append(pair)
    }

    private func extractSwiftUI(_ node: MemberAccessExprSyntax) -> AccessibilityIdentifierPair? {
        guard
            let tuple = node.parent?.firstSearchingDown(of: LabeledExprListSyntax.self),
            let value = Syntax(tuple).firstSearchingDown(of: StringSegmentSyntax.self)?.content.text,
            let enclosingView = Syntax(node).firstSearchingUp(of: StructDeclSyntax.self)
            else { return nil }

        return .init(parent: enclosingView.name.text, identifier: value)
    }

    private func extractUIKit(_ node: MemberAccessExprSyntax) -> AccessibilityIdentifierPair? {
        guard
            let infixExpr = node.parent?.as(InfixOperatorExprSyntax.self),
            let value = Syntax(infixExpr).firstSearchingDown(of: StringSegmentSyntax.self)?.content.text,
            let enclosingClass = Syntax(node).firstSearchingUp(of: ClassDeclSyntax.self)
            else { return nil }

        return .init(parent: enclosingClass.name.text, identifier: value)
    }
}

extension Syntax {
    func firstSearchingUp<T: SyntaxProtocol>(of: T.Type, where predicate: (T) -> Bool = { _ in true }) -> T? {
        if let result = self.as(T.self), predicate(result) { return result }
        return parent?.firstSearchingUp(of: T.self, where: predicate)
    }
    func firstSearchingDown<T: SyntaxProtocol>(of: T.Type, where predicate: (T) -> Bool = { _ in true }) -> T? {
        if let result = self.as(T.self), predicate(result) { return result }

        var queue: [Syntax] = [self]

        while let item = queue.first {
            if let result = item.as(T.self), predicate(result) {
                return result
            }
            queue.removeFirst()

            queue.append(contentsOf: item.children(viewMode: .sourceAccurate).map { $0 })
        }

        return nil
    }
}

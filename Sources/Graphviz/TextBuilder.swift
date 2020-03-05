import Foundation

public struct TextBuilder {
    public private(set) var text: String = ""
    
    private var depth: Int = 0
    private var needsIndent: Bool = true
    
    public mutating func push() {
        depth += 1
    }
    
    public mutating func pop() {
        depth -= 1
    }
    
    public mutating func nest(_ f: (inout TextBuilder) throws -> Void) rethrows {
        push()
        defer {
            pop()
        }
        try f(&self)
    }
    
    public mutating func write(_ text: String, newLine: Bool = true) {
        indentIfNeed()
        self.text += text
        if newLine {
            self.text += "\n"
            needsIndent = true
        }
    }
    
    private mutating func indentIfNeed() {
        guard needsIndent else { return }
        
        text += String(repeating: "  ", count: depth)
        
        needsIndent = false
    }
}

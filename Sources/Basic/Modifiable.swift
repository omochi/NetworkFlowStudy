public protocol Modifiable {}

extension Modifiable {
    public mutating func modify(_ f: (inout Self) throws -> Void) rethrows {
        try f(&self)
    }
}

import XCTest
import PrimalDual

public final class PrimalDual2Tests: XCTestCase {
    public func testSolve1() {
        // http://dopal.cs.uec.ac.jp/okamotoy/lect/2013/opt/handout13.pdf
        
        var g = Graph(source: 0, sink: 5)
        for _ in 0...5 {
            g.addVertex()
        }
        
        g.addEdge(tail: 0, head: 1, capacity: 2, cost: 2)
        g.addEdge(tail: 0, head: 3, capacity: 7, cost: 4)
        g.addEdge(tail: 1, head: 2, capacity: 4, cost: 6)
        g.addEdge(tail: 1, head: 3, capacity: 2, cost: 1)
        g.addEdge(tail: 2, head: 5, capacity: 7, cost: 2)
        g.addEdge(tail: 3, head: 2, capacity: 1, cost: 6)
        g.addEdge(tail: 3, head: 4, capacity: 6, cost: 2)
        g.addEdge(tail: 4, head: 2, capacity: 3, cost: 2)
        g.addEdge(tail: 4, head: 5, capacity: 2, cost: 7)
        
        g.primalDual2(amount: 4)
        
        XCTAssertEqual(g.cost(), 39)
    }
}
import XCTest
import PrimalDual

public final class PrimalDual2Tests: XCTestCase {
    public func testSolve1() {
        // http://dopal.cs.uec.ac.jp/okamotoy/lect/2013/opt/handout13.pdf
        
        var g = Graph(source: 0, sink: 5,
                      vertexCount: 6)
        
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
    
    public func testSolve2() {
        // original
        
        var g = Graph(source: 0, sink: 8, vertexCount: 9)
        
        g.addEdge(tail: 0, head: 1, capacity: 3, cost: 2)
        g.addEdge(tail: 0, head: 2, capacity: 3, cost: 1)
        g.addEdge(tail: 1, head: 3, capacity: 2, cost: 2)
        g.addEdge(tail: 1, head: 6, capacity: 1, cost: 1)
        g.addEdge(tail: 2, head: 4, capacity: 1, cost: 1)
        g.addEdge(tail: 2, head: 5, capacity: 2, cost: 2)
        g.addEdge(tail: 3, head: 6, capacity: 4, cost: 3)
        g.addEdge(tail: 4, head: 3, capacity: 4, cost: 3)
        g.addEdge(tail: 4, head: 7, capacity: 5, cost: 3)
        g.addEdge(tail: 5, head: 6, capacity: 2, cost: 2)
        g.addEdge(tail: 5, head: 7, capacity: 4, cost: 3)
        g.addEdge(tail: 6, head: 8, capacity: 3, cost: 2)
        g.addEdge(tail: 7, head: 8, capacity: 6, cost: 3)
        
        g.primalDual2(amount: 100)
        
        XCTAssertEqual(g.cost(), 49)
    }
    
    public func testSolve3() {
        // dolpen
        
        var g = Graph(source: 0, sink: 5, vertexCount: 6)
        
        g.addEdge(tail: 0, head: 1, capacity: 1, cost: 1)
        g.addEdge(tail: 0, head: 2, capacity: 1, cost: 1)
        g.addEdge(tail: 1, head: 3, capacity: 1, cost: 2)
        g.addEdge(tail: 1, head: 4, capacity: 1, cost: 1)
        g.addEdge(tail: 2, head: 4, capacity: 1, cost: 2)
        g.addEdge(tail: 3, head: 5, capacity: 1, cost: 1)
        g.addEdge(tail: 4, head: 5, capacity: 1, cost: 1)
        
        g.primalDual2(amount: 2)
        
        XCTAssertEqual(g.cost(), 8)
    }

}

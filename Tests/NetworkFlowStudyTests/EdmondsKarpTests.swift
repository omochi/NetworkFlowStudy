import XCTest
import EdmondsKarp

public final class EdmondsKarpTests: XCTestCase {
    func testReverseFlow() {
        // http://hos.ac/slides/20150319_flow.pdf
        
        var g = Graph(source: 0, sink: 5)
        for _ in 0...5 {
            g.addVertex()
        }
        
        g.addEdge(tail: 0, head: 1, capacity: 9, used: 6)
        g.addEdge(tail: 0, head: 2, capacity: 9, used: 4)
        g.addEdge(tail: 1, head: 2, capacity: 1, used: 1)
        g.addEdge(tail: 1, head: 3, capacity: 3, used: 3)
        g.addEdge(tail: 1, head: 4, capacity: 7, used: 2)
        g.addEdge(tail: 2, head: 4, capacity: 8, used: 5)
        g.addEdge(tail: 3, head: 5, capacity: 9, used: 4)
        g.addEdge(tail: 4, head: 3, capacity: 5, used: 1)
        g.addEdge(tail: 4, head: 5, capacity: 9, used: 6)
        
        g.addFlow(Flow(path: [0, 2, 1, 4, 5], amount: 1))
        
        XCTAssertEqual(g.edge(at: g.edge(tail: 0, head: 2)!).used, 5)
        XCTAssertEqual(g.edge(at: g.edge(tail: 1, head: 2)!).used, 0)
        XCTAssertEqual(g.edge(at: g.edge(tail: 1, head: 4)!).used, 3)
        XCTAssertEqual(g.edge(at: g.edge(tail: 4, head: 5)!).used, 7)
    }
    
    func testSolve1() {
        // http://hos.ac/slides/20150319_flow.pdf
        
        var g = Graph(source: 0, sink: 5)
        for _ in 0...5 {
            g.addVertex()
        }
        
        g.addEdge(tail: 0, head: 1, capacity: 9)
        g.addEdge(tail: 0, head: 2, capacity: 9)
        g.addEdge(tail: 1, head: 2, capacity: 1)
        g.addEdge(tail: 1, head: 3, capacity: 3)
        g.addEdge(tail: 1, head: 4, capacity: 7)
        g.addEdge(tail: 2, head: 4, capacity: 8)
        g.addEdge(tail: 3, head: 5, capacity: 9)
        g.addEdge(tail: 4, head: 3, capacity: 5)
        g.addEdge(tail: 4, head: 5, capacity: 9)

        g.edmondsKarp()
    
        do {
            let edges = g.edges(from: g.source).map { g.edge(at: $0) }
            let sum = edges.reduce(0) { (s, x) in s + x.used }
            XCTAssertEqual(sum, 17)
        }
        
        do {
            let edges = g.edges(to: g.sink).map { g.edge(at: $0) }
            let sum = edges.reduce(0) { (s, x) in s + x.used }
            XCTAssertEqual(sum, 17)
        }
    }
    
    func testSolve2() {
        // https://en.wikipedia.org/wiki/Edmonds–Karp_algorithm
        
        var g = Graph(source: 0, sink: 6)
        for _ in 0...6 {
            g.addVertex()
        }

        g.addEdge(tail: 0, head: 1, capacity: 3)
        g.addEdge(tail: 0, head: 3, capacity: 3)
        g.addEdge(tail: 1, head: 2, capacity: 4)
        g.addEdge(tail: 2, head: 0, capacity: 3)
        g.addEdge(tail: 2, head: 3, capacity: 1)
        g.addEdge(tail: 2, head: 4, capacity: 2)
        g.addEdge(tail: 3, head: 4, capacity: 2)
        g.addEdge(tail: 3, head: 5, capacity: 6)
        g.addEdge(tail: 4, head: 6, capacity: 1)
        g.addEdge(tail: 5, head: 6, capacity: 9)
        
        g.edmondsKarp()
        
        do {
            let edges = g.edges(from: g.source).map { g.edge(at: $0) }
            let sum = edges.reduce(0) { (s, x) in s + x.used }
            XCTAssertEqual(sum, 5)
        }
        
        do {
            let edges = g.edges(to: g.sink).map { g.edge(at: $0) }
            let sum = edges.reduce(0) { (s, x) in s + x.used }
            XCTAssertEqual(sum, 5)
        }
    }
}

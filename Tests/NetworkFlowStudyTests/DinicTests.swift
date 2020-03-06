import XCTest
import Basic
import Graphviz
import EdmondsKarp
import Dinic

public final class DinicTests: XCTestCase {
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

        g.dinic()
    
        do {
            let edges = g.edges(from: g.source).map { g.edge(at: $0) }
            let sum = edges.map(\.used).reduce(0, +)
            XCTAssertEqual(sum, 17)
        }
        
        do {
            let edges = g.edges(to: g.sink).map { g.edge(at: $0) }
            let sum = edges.map(\.used).reduce(0, +)
            XCTAssertEqual(sum, 17)
        }
    }
    
    func testSolve2() {
        // https://en.wikipedia.org/wiki/Dinic%27s_algorithm
        
        var g = Graph(source: 0, sink: 5)
        
        for _ in 0...5 {
            g.addVertex()
        }
        
        g.addEdge(tail: 0, head: 1, capacity: 10)
        g.addEdge(tail: 0, head: 2, capacity: 10)
        g.addEdge(tail: 1, head: 2, capacity: 2)
        g.addEdge(tail: 1, head: 3, capacity: 4)
        g.addEdge(tail: 1, head: 4, capacity: 8)
        g.addEdge(tail: 2, head: 4, capacity: 9)
        g.addEdge(tail: 3, head: 5, capacity: 10)
        g.addEdge(tail: 4, head: 3, capacity: 6)
        g.addEdge(tail: 4, head: 5, capacity: 10)
        
        let tempDir = fm.temporaryDirectory
            .appendingPathComponent(Randoms.randomString(length: 12))
        g.imageWriter = ImageWriter(directory: tempDir)
        g.dinic()
        
        do {
            let edges = g.edges(from: g.source).map { g.edge(at: $0) }
            let sum = edges.map(\.used).reduce(0, +)
            XCTAssertEqual(sum, 19)
        }
        
        do {
            let edges = g.edges(to: g.sink).map { g.edge(at: $0) }
            let sum = edges.map(\.used).reduce(0, +)
            XCTAssertEqual(sum, 19)
        }
    }
}

import XCTest
import EdmondsKarp

public final class EdmondsKarpTests: XCTestCase {
    func testSolve1() {
        var g = Graph(source: 0, sink: 5)
        g.addVertex(edges: [Edge(head: 1, size: 9),
                            Edge(head: 2, size: 9)])
        g.addVertex(edges: [Edge(head: 2, size: 1),
                            Edge(head: 3, size: 3),
                            Edge(head: 4, size: 7)])
        g.addVertex(edges: [Edge(head: 4, size: 8)])
        g.addVertex(edges: [Edge(head: 5, size: 9)])
        g.addVertex(edges: [Edge(head: 3, size: 5),
                            Edge(head: 5, size: 9)])
        g.addVertex(edges: [])

        let r = g.edmondsKarp()
    
        do {
            let edges = r.vertices[r.source].edges
            let sum = edges.reduce(0) { (s, x) in s + x.used }
            XCTAssertEqual(sum, 17)
        }
        
        do {
            let edges = r.edges(to: r.sink).map { r.edge(at: $0) }
            let sum = edges.reduce(0) { (s, x) in s + x.used }
            XCTAssertEqual(sum, 17)
        }
    }
    
    func testReverseFlow() {
        var g = Graph(source: 0, sink: 5)
        g.addVertex(edges: [Edge(head: 1, size: 9, used: 6),
                            Edge(head: 2, size: 9, used: 4)])
        g.addVertex(edges: [Edge(head: 2, size: 1, used: 1),
                            Edge(head: 3, size: 3, used: 3),
                            Edge(head: 4, size: 7, used: 2)])
        g.addVertex(edges: [Edge(head: 4, size: 8, used: 5)])
        g.addVertex(edges: [Edge(head: 5, size: 9, used: 4)])
        g.addVertex(edges: [Edge(head: 3, size: 5, used: 1),
                            Edge(head: 5, size: 9, used: 6)])
        g.addVertex(edges: [])
        
        g.add(path: [0, 2, 1, 4, 5], amount: 1)
        
        XCTAssertEqual(g.vertices[0].edge(to: 2)!.used, 5)
        XCTAssertEqual(g.vertices[1].edge(to: 2)!.used, 0)
        XCTAssertEqual(g.vertices[1].edge(to: 4)!.used, 3)
        XCTAssertEqual(g.vertices[4].edge(to: 5)!.used, 7)
    }
}

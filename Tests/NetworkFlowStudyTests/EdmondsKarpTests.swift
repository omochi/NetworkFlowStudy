import XCTest
import EdmondsKarp

public final class EdmondsKarpTests: XCTestCase {
    func testReverseFlow() {
        // http://hos.ac/slides/20150319_flow.pdf
        
        var g = Graph(source: 0, sink: 5)
        g.addVertex(edges: [Edge(head: 1, capacity: 9, used: 6),
                            Edge(head: 2, capacity: 9, used: 4)])
        g.addVertex(edges: [Edge(head: 2, capacity: 1, used: 1),
                            Edge(head: 3, capacity: 3, used: 3),
                            Edge(head: 4, capacity: 7, used: 2)])
        g.addVertex(edges: [Edge(head: 4, capacity: 8, used: 5)])
        g.addVertex(edges: [Edge(head: 5, capacity: 9, used: 4)])
        g.addVertex(edges: [Edge(head: 3, capacity: 5, used: 1),
                            Edge(head: 5, capacity: 9, used: 6)])
        g.addVertex(edges: [])
        
        g.add(path: [0, 2, 1, 4, 5], amount: 1)
        
        XCTAssertEqual(g.vertices[0].edge(to: 2)!.used, 5)
        XCTAssertEqual(g.vertices[1].edge(to: 2)!.used, 0)
        XCTAssertEqual(g.vertices[1].edge(to: 4)!.used, 3)
        XCTAssertEqual(g.vertices[4].edge(to: 5)!.used, 7)
    }
    
    func testSolve1() {
        // http://hos.ac/slides/20150319_flow.pdf
        
        var g = Graph(source: 0, sink: 5)
        g.addVertex(edges: [Edge(head: 1, capacity: 9),
                            Edge(head: 2, capacity: 9)])
        g.addVertex(edges: [Edge(head: 2, capacity: 1),
                            Edge(head: 3, capacity: 3),
                            Edge(head: 4, capacity: 7)])
        g.addVertex(edges: [Edge(head: 4, capacity: 8)])
        g.addVertex(edges: [Edge(head: 5, capacity: 9)])
        g.addVertex(edges: [Edge(head: 3, capacity: 5),
                            Edge(head: 5, capacity: 9)])
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
    
    func testSolve2() {
        // https://en.wikipedia.org/wiki/Edmonds–Karp_algorithm
        
        var g = Graph(source: 0, sink: 6)
        g.addVertex(edges: [Edge(head: 1, capacity: 3),
                            Edge(head: 3, capacity: 3)])
        g.addVertex(edges: [Edge(head: 2, capacity: 4)])
        g.addVertex(edges: [Edge(head: 0, capacity: 3),
                            Edge(head: 3, capacity: 1),
                            Edge(head: 4, capacity: 2)])
        g.addVertex(edges: [Edge(head: 4, capacity: 2),
                            Edge(head: 5, capacity: 6)])
        g.addVertex(edges: [Edge(head: 6, capacity: 1)])
        g.addVertex(edges: [Edge(head: 6, capacity: 9)])
        g.addVertex(edges: [])
        
        let r = g.edmondsKarp()
        
        do {
            let edges = r.vertices[r.source].edges
            let sum = edges.reduce(0) { (s, x) in s + x.used }
            XCTAssertEqual(sum, 5)
        }
        
        do {
            let edges = r.edges(to: r.sink).map { r.edge(at: $0) }
            let sum = edges.reduce(0) { (s, x) in s + x.used }
            XCTAssertEqual(sum, 5)
        }
    }
}

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
    
        assertFlowAmount(graph: g, amount: 17)
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
        
        g.dinic()
        
        assertFlowAmount(graph: g, amount: 19)
    }
    
    func testSolve3() {
        // https://www.slideshare.net/KuoE0/acmicpc-dinics-algorithm
        
        var g = Graph(source: 0, sink: 9)
        g.imageWriter = .default
        
        for _ in 0...9 {
            g.addVertex()
        }
        
        g.addEdge(tail: 0, head: 1, capacity: 30)
        g.addEdge(tail: 0, head: 2, capacity: 10)
        g.addEdge(tail: 1, head: 3, capacity: 15)
        g.addEdge(tail: 1, head: 4, capacity: 5)
        g.addEdge(tail: 2, head: 4, capacity: 5)
        g.addEdge(tail: 2, head: 5, capacity: 5)
        g.addEdge(tail: 3, head: 6, capacity: 10)
        g.addEdge(tail: 3, head: 7, capacity: 10)
        g.addEdge(tail: 4, head: 7, capacity: 5)
        g.addEdge(tail: 4, head: 8, capacity: 5)
        g.addEdge(tail: 5, head: 8, capacity: 6)
        g.addEdge(tail: 6, head: 9, capacity: 15)
        g.addEdge(tail: 7, head: 9, capacity: 7)
        g.addEdge(tail: 8, head: 9, capacity: 10)
        
        g.dinic()
        
        assertFlowAmount(graph: g, amount: 27)
    }
}

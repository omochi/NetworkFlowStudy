import XCTest
import EdmondsKarp

public final class EdmondsKarpTests: XCTestCase {
    func test1() {
        var graph = Graph(vertices: [
            Vertex(
                id: 1,
                edges: [
                    Edge(head: 2, size: 9),
                    Edge(head: 3, size: 9),
                ]
            ),
            Vertex(
                id: 2,
                edges: [
                    Edge(head: 3, size: 1),
                    Edge(head: 4, size: 3),
                    Edge(head: 5, size: 7),
                ]
            ),
            Vertex(
                id: 3,
                edges: [
                    Edge(head: 5, size: 8)
                ]
            ),
            Vertex(
                id: 4,
                edges: [
                    Edge(head: 6, size: 9)
                ]
            ),
            Vertex(
                id: 5,
                edges: [
                    Edge(head: 4, size: 5),
                    Edge(head: 6, size: 9)
                ]
            ),
            Vertex(id: 6)
        ])
        print(graph.draw())
    }
}

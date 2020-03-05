import XCTest
import EdmondsKarp

public final class EdmondsKarpTests: XCTestCase {
    func test1() {
        var graph = Graph(vertices: [
            Vertex(
                id: 1,
                edges: [
                    Edge(end: 2, size: 9),
                    Edge(end: 3, size: 9),
                ]
            ),
            Vertex(id: 2
            ),
            Vertex(id: 3
            ),
            Vertex(id: 4
            ),
            Vertex(id: 5
            ),
            Vertex(id: 6)
        ])
        print(graph.draw())
    }
}

import Graphviz

public struct Vertex {
    public var id: Int
    public var edges: [Edge]
    
    public init(id: Int, edges: [Edge] = []) {
        self.id = id
        self.edges = edges
    }
}

public struct Edge {
    public var head: Int
    public var size: Int
    public var used: Int
    
    public init(head: Int,
                size: Int,
                used: Int = 0)
    {
        self.head = head
        self.size = size
        self.used = used
    }
}

public struct Graph {
    public var vertices: [Vertex]
    
    public init(vertices: [Vertex]) {
        self.vertices = vertices
    }
    
    public func draw() -> String {
        var g = VGraph(name: "g")
        for v in vertices {
            g.nodes.append(
                VNode(name: "\(v.id)")
            )
            for e in v.edges {
                g.edges.append(
                    VEdge(
                        tail: "\(v.id)",
                        head: "\(e.head)",
                        label: "\(e.used)/\(e.size)"
                    )
                )
            }
        }
        return g.description
    }
}



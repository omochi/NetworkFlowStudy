import Basic
import Graphviz

public struct Vertex {
    public var edges: [Edge] = []
    
    public init() {}
    
    public func edgeIndex(to head: Int) -> Int? {
        edges.firstIndex { $0.head == head }
    }
    
    public func edge(to head: Int) -> Edge? {
        edges.first { $0.head == head }
    }
}

public struct Edge: Modifiable {
    public var head: Int
    public var capacity: Int
    public var used: Int
    public var rem: Int { capacity - used }
    public var reverse: Int
    
    public init(head: Int,
                capacity: Int,
                used: Int,
                reverse: Int)
    {
        self.head = head
        self.capacity = capacity
        self.used = used
        self.reverse = reverse
    }
}

public struct EdgeSpecifier {
    public var tail: Int
    public var index: Int
}

public struct Graph {
    public private(set) var vertices: [Vertex]
    public var source: Int
    public var sink: Int
    
    public var imageWriter: ImageWriter?
    
    public init(source: Int,
                sink: Int)
    {
        self.vertices = []
        self.source = source
        self.sink = sink
    }
  
    @discardableResult
    public mutating func addVertex() -> Int {
        let index = vertices.count
        let vertex = Vertex()
        vertices.append(vertex)
        return index
    }
    
    public mutating func addEdge(tail: Int, head: Int,
                                 capacity: Int, used: Int = 0)
    {
        var v0 = vertices[tail]
        var v1 = vertices[head]
        v0.edges.append(Edge(head: head, capacity: capacity, used: used, reverse: v1.edges.count))
        v1.edges.append(Edge(head: tail, capacity: 0, used: -used, reverse: v0.edges.count - 1))
        vertices[tail] = v0
        vertices[head] = v1
    }
    
    public func edge(tail: Int, head: Int) -> EdgeSpecifier? {
        guard let index = vertices[tail].edgeIndex(to: head) else { return nil }
        return EdgeSpecifier(tail: tail, index: index)
    }
        
    public func edge(at specifier: EdgeSpecifier) -> Edge {
        vertices[specifier.tail].edges[specifier.index]
    }
    
    public func edges(from tail: Int) -> [EdgeSpecifier] {
        vertices[tail].edges.indices.map { (index) in
            EdgeSpecifier(tail: tail, index: index) }
    }
    
    public func edges(to head: Int) -> [EdgeSpecifier] {
        vertices[head].edges.map { (e) in
            EdgeSpecifier(tail: e.head, index: e.reverse)
        }
    }
    
    public mutating func addFlow(_ flow: Flow) {
        for i in 0..<(flow.path.count - 1) {
            addFlow(from: flow.path[i], to: flow.path[i + 1], amount: flow.amount)
        }
    }
    
    public mutating func addFlow(
        from tail: Int,
        to head: Int,
        amount: Int)
    {
        guard let ei = vertices[tail].edgeIndex(to: head) else {
            preconditionFailure("invalid edge")
        }
        
        var rei: Int!
        vertices[tail].edges[ei].modify { (e) in
            e.used += amount
            rei = e.reverse
        }
        
        vertices[head].edges[rei].modify { (e) in
            e.used -= amount
        }
    }
    
    public func toGraphviz() -> VGraph {
        var g = VGraph(name: "g")
        for i in vertices.indices {
            g.nodes.append(
                VNode(name: "\(i)")
            )
            for e in vertices[i].edges {
                g.edges.append(
                    VEdge(
                        tail: "\(i)",
                        head: "\(e.head)",
                        label: "\(e.used)/\(e.capacity)"
                    )
                )
            }
        }
        return g
    }
    
    public func writeImage() {
        try! imageWriter?.write(graph: toGraphviz())
    }
}

public struct Flow {
    public var path: [Int]
    public var amount: Int

    public init(path: [Int], amount: Int) {
        self.path = path
        self.amount = amount
    }
}

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
    public var remainder: Int { capacity - used }
    public var cost: Int
    public var reverse: Int
    
    public init(head: Int,
                capacity: Int,
                used: Int,
                cost: Int,
                reverse: Int)
    {
        self.head = head
        self.capacity = capacity
        self.used = used
        self.cost = cost
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
                sink: Int,
                vertexCount: Int)
    {
        self.vertices = []
        self.source = source
        self.sink = sink
        
        self.vertices = Array(repeating: Vertex(), count: vertexCount)
    }

    public mutating func addEdge(tail: Int, head: Int,
                                 capacity: Int, used: Int = 0,
                                 cost: Int)
    {
        var v0 = vertices[tail]
        var v1 = vertices[head]
        v0.edges.append(Edge(head: head, capacity: capacity, used: used, cost: cost, reverse: v1.edges.count))
        v1.edges.append(Edge(head: tail, capacity: 0, used: -used, cost: -cost, reverse: v0.edges.count - 1))
        vertices[tail] = v0
        vertices[head] = v1
    }
    
    public func edge(tail: Int, head: Int) -> EdgeSpecifier? {
        vertices[tail].edgeIndex(to: head).map {
            EdgeSpecifier(tail: tail, index: $0)
        }
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
    
    public func remainder(from tail: Int, to head: Int) -> Int {
        guard let e = vertices[tail].edge(to: head) else {
            preconditionFailure("no edge")
        }
        
        return e.remainder
    }
    
    public func remainder(of path: [Int]) -> Int {
        precondition(path.count >= 2)
        
        var amount = remainder(from: path[0], to: path[1])
        for i in 1..<(path.count - 1) {
            amount = min(amount, remainder(from: path[i], to: path[i + 1]))
        }
        return amount
    }
    
    public mutating func addFlow(path: Path, amount: Int) {
        for i in 0..<(path.count - 1) {
            addFlow(from: path[i], to: path[i + 1], amount: amount)
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
    
    public func cost() -> Int {
        var cost = 0
        for v in vertices {
            for e in v.edges {
                guard e.capacity > 0 else { continue }
                cost += e.used * e.cost
            }
        }
        return cost
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
                        label: "\(e.used)/\(e.capacity) [\(e.cost)]"
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

public typealias Path = [Int]

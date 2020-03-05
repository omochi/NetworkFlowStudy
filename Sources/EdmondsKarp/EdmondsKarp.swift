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
        var i = 0
        while i + 1 < flow.path.count {
            let v0 = flow.path[i]
            let v1 = flow.path[i + 1]
            
            guard let ei = vertices[v0].edgeIndex(to: v1) else {
                preconditionFailure("invalid path")
            }
            
            var e0 = vertices[v0].edges[ei]
            e0.used += flow.amount
            vertices[v0].edges[ei] = e0
            
            var e1 = vertices[e0.head].edges[e0.reverse]
            e1.used -= flow.amount
            vertices[e0.head].edges[e0.reverse] = e1

            i += 1
        }
    }
    
    public func draw() -> String {
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
        return g.description
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

extension Graph {
    internal func breadthFirstSearch() -> Flow? {
        struct VertexInfo {
            var isFound: Bool = false
            var tail: Int?
            var capacity: Int = .max
        }
        
        var infos = vertices.map { (_) in VertexInfo() }
        var nexts: [Int] = [source]
        
        while true {
            guard let current = nexts.first else {
                return nil
            }
            nexts.removeFirst()

            if current == sink {
                var i = current
                var revPath: [Int] = [i]
                while true {
                    if i == source { break }
                    i = infos[i].tail!
                    revPath.append(i)
                }
                return Flow(path: revPath.reversed(),
                            amount: infos[current].capacity)
            }
            
            for e in vertices[current].edges {
                guard e.rem > 0 else { continue }
                
                let v = e.head
                if infos[v].isFound { continue }
                
                infos[v].isFound = true
                infos[v].tail = current
                infos[v].capacity = min(infos[current].capacity, e.rem)
                nexts.append(v)
            }
        }
    }
    
    internal func capacity(from tail: Int, to head: Int) -> Int {
        guard let e = vertices[tail].edge(to: head) else {
            preconditionFailure("no edge")
        }
        
        return e.rem
    }
    
    internal func capacity(of path: [Int]) -> Int {
        precondition(path.count >= 2)
        
        var amount = capacity(from: path[0], to: path[1])
        for i in 1..<(path.count - 1) {
            amount = min(amount, capacity(from: path[i], to: path[i + 1]))
        }
        return amount
    }
    
    public mutating func edmondsKarp() {
        while true {
            guard let flow = breadthFirstSearch() else {
                return
            }
            addFlow(flow)
        }
    }
}

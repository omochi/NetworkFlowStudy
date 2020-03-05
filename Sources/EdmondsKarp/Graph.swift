import Basic
import Graphviz

public struct Vertex {
    public var outEdges: [Edge] = []
    public var inEdges: [EdgeSpecifier] = []
    
    public init() {}
    
    public func outEdgeIndex(to head: Int) -> Int? {
        outEdges.firstIndex { $0.head == head }
    }
    
    public func outEdge(to head: Int) -> Edge? {
        outEdges.first { $0.head == head }
    }
    
    public func inEdge(from tail: Int) -> EdgeSpecifier? {
        inEdges.first { $0.tail == tail }
    }
}

public struct Edge: Modifiable {
    public var head: Int
    public var capacity: Int
    public var used: Int
    public var rem: Int { capacity - used }
    
    public init(head: Int,
                capacity: Int,
                used: Int = 0)
    {
        self.head = head
        self.capacity = capacity
        self.used = used
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
        let edgeIndex = v0.outEdges.count
        v0.outEdges.append(Edge(head: head, capacity: capacity, used: used))
        v1.inEdges.append(EdgeSpecifier(tail: tail, index: edgeIndex))
        vertices[tail] = v0
        vertices[head] = v1
    }
    
    public func edge(tail: Int, head: Int) -> EdgeSpecifier? {
        guard let index = vertices[tail].outEdgeIndex(to: head) else { return nil }
        return EdgeSpecifier(tail: tail, index: index)
    }
        
    public func edge(at specifier: EdgeSpecifier) -> Edge {
        vertices[specifier.tail].outEdges[specifier.index]
    }
    
    public func edges(from tail: Int) -> [EdgeSpecifier] {
        vertices[tail].outEdges.indices.map { (index) in
            EdgeSpecifier(tail: tail, index: index) }
    }
    
    public func edges(to head: Int) -> [EdgeSpecifier] {
        vertices[head].inEdges
    }
    
    public mutating func addFlow(path: [Int], amount: Int) {
        var i = 0
        while i + 1 < path.count {
            let v0 = path[i]
            let v1 = path[i + 1]
            
            if let edgeIndex = vertices[v0].outEdgeIndex(to: v1) {
                vertices[v0].outEdges[edgeIndex].modify { (e) in
                    e.used += amount
                }
            } else if let edgeIndex = vertices[v1].outEdgeIndex(to: v0) {
                vertices[v1].outEdges[edgeIndex].modify { (e) in
                    e.used -= amount
                }
            } else {
                preconditionFailure("invalid path")
            }

            i += 1
        }
    }
    
    public func draw() -> String {
        var g = VGraph(name: "g")
        for i in vertices.indices {
            g.nodes.append(
                VNode(name: "\(i)")
            )
            for e in vertices[i].outEdges {
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

extension Graph {
    internal func breadthFirstSearch() -> [Int]? {
        struct VertexInfo {
            public var isFound: Bool = false
            public var tail: Int?
        }
        
        var infos = vertices.map { (_) in VertexInfo() }
        var nexts: [Int] = [source]
        
        func found(_ v: Int, from: Int) {
            if infos[v].isFound { return }
            
            infos[v].isFound = true
            infos[v].tail = from
            nexts.append(v)
        }
        
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
                return revPath.reversed()
            }
            
            for e in vertices[current].outEdges {
                guard e.rem > 0 else { continue }
                
                found(e.head, from: current)
            }
            for ei in vertices[current].inEdges {
                let e = edge(at: ei)
                
                guard e.used > 0 else { continue }
                
                found(ei.tail, from: current)
            }
        }
    }
    
    internal func capacity(from tail: Int, to head: Int) -> Int {
        if let e = vertices[tail].outEdge(to: head) {
            return e.rem
        }
        if let e = vertices[head].outEdge(to: tail) {
            return e.used
        }
        preconditionFailure("no edge")
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
            guard let path = breadthFirstSearch() else {
                return
            }
            
            let amount = self.capacity(of: path)
            
            addFlow(path: path, amount: amount)
        }
    }
}

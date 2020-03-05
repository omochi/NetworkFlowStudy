import Basic
import Graphviz

public struct Vertex {
    public var edges: [Edge]
    
    public init(edges: [Edge])
    {
        self.edges = edges
    }
    
    public func edgeIndex(to head: Int) -> Int? {
        edges.firstIndex { $0.head == head }
    }
    
    public func edge(to head: Int) -> Edge? {
        edges.first { $0.head == head }
    }
    
    public mutating func modifyEdge(to head: Int, _ f: (inout Edge) -> Void) {
        let index = edges.firstIndex { $0.head == head }!
        f(&edges[index])
    }
}

public struct Edge: Modifiable {
    public var head: Int
    public var size: Int
    public var used: Int
    public var rem: Int { size - used }
    
    public init(head: Int,
                size: Int,
                used: Int = 0)
    {
        self.head = head
        self.size = size
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
    public mutating func addVertex(edges: [Edge]) -> Int {
        let index = vertices.count
        let vertex = Vertex(
            edges: edges)
        vertices.append(vertex)
        return index
    }
    
    public func edge(at specifier: EdgeSpecifier) -> Edge {
        vertices[specifier.tail].edges[specifier.index]
    }
    
    public func edges(to head: Int) -> [EdgeSpecifier] {
        var ret: [EdgeSpecifier] = []
        for tail in vertices.indices {
            let v = vertices[tail]
            for index in v.edges.indices {
                let e = v.edges[index]
                if e.head == head {
                    ret.append(EdgeSpecifier(tail: tail, index: index))
                }
            }
        }
        return ret
    }
    
    public mutating func add(path: [Int], amount: Int) {
        var i = 0
        while i + 1 < path.count {
            let v0 = path[i]
            let v1 = path[i + 1]
            
            if let edgeIndex = vertices[v0].edgeIndex(to: v1) {
                vertices[v0].edges[edgeIndex].modify { (e) in
                    e.used += amount
                }
            } else if let edgeIndex = vertices[v1].edgeIndex(to: v0) {
                vertices[v1].edges[edgeIndex].modify { (e) in
                    e.used -= amount
                }
            } else {
                preconditionFailure("invalid path")
            }

            i += 1
        }
    }
    
    public func residual() -> Graph {
        var g = Graph(source: source, sink: sink)
        for v in vertices {
            g.addVertex(edges: [])
        }
        for i in vertices.indices {
            for e in vertices[i].edges {
                if e.rem > 0 {
                    g.vertices[i].edges.append(
                        Edge(head: e.head, size: e.rem)
                    )
                }
                if e.used > 0 {
                    g.vertices[e.head].edges.append(
                        Edge(head: i, size: e.used)
                    )
                }
            }
        }
        return g
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
                        label: "\(e.used)/\(e.size)"
                    )
                )
            }
        }
        return g.description
    }
}

extension Graph {
    public func breadthFirstSearch() -> [Int]? {
        struct VertexInfo {
            public var isFound: Bool = false
            public var isVisited: Bool = false
            public var head: Int?
        }
        
        var infos = vertices.map { (_) in VertexInfo() }
        
        var nexts: [Int] = [source]
        while true {
            guard let current = nexts.first else {
                return nil
            }
            nexts.removeFirst()
            
            if infos[current].isVisited {
                continue
            }
            
            infos[current].isVisited = true
            
            if current == sink {
                var i = current
                var revPath: [Int] = [i]
                while true {
                    if i == source { break }
                    i = infos[i].head!
                    revPath.append(i)
                }
                return revPath.reversed()
            }
            
            for e in vertices[current].edges {
                if infos[e.head].isFound { continue }
            
                infos[e.head].isFound = true
                infos[e.head].head = current
                nexts.append(e.head)
            }
        }
    }
    
    public func amount(of path: [Int]) -> Int {
        precondition(path.count >= 2)
        
        let firstEdge = vertices[path[0]].edge(to: path[1])!
        var amount = firstEdge.rem
        var i = 1
        while i + 1 < path.count {
            let edge = vertices[path[i]].edge(to: path[i + 1])!
            amount = min(amount, edge.rem)
            i += 1
        }
        return amount
    }
    
    public func edmondsKarp() -> Graph {
        var g = self
        
        while true {
            let r = g.residual()
            
            guard let path = r.breadthFirstSearch() else {
                return g
            }
            
            let amount = r.amount(of: path)
            
            g.add(path: path, amount: amount)
            
            print(g.draw())
        }
    }
}

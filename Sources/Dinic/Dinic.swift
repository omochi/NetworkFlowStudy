import EdmondsKarp

extension Graph {
    internal func breadthFirstSearch(depths: inout [Int]) -> Bool {
        struct VertexInfo {
            var isFound: Bool = false
            var tail: Int?
            var capacity: Int = .max
        }
        
        var infos = vertices.map { (_) in VertexInfo() }
        var nexts: [Int] = [source]
        infos[source].isFound = true
        depths[source] = 0
        
        while true {
            guard let current = nexts.first else {
                return false
            }
            nexts.removeFirst()

            if current == sink {
                return true
            }
            
            for e in vertices[current].edges {
                guard e.rem > 0 else { continue }
                
                let v = e.head
                if infos[v].isFound { continue }
                
                infos[v].isFound = true
                infos[v].tail = current
                infos[v].capacity = min(infos[current].capacity, e.rem)
                depths[v] = depths[current] + 1
                nexts.append(v)
            }
        }
    }

    internal struct DFS {
        struct _Flow {
            var reversedPath: [Int]
            var amount: Int
            
            func toFlow() -> Flow {
                Flow(path: reversedPath.reversed(),
                     amount: amount)
            }
        }
        
        var depths: [Int]
        var startIndices: [Int]
        
        init(depths: [Int])
        {
            self.depths = depths
            self.startIndices = Array(repeating: 0, count: depths.count)
        }
        
        mutating func _search(graph: Graph,
                              start: Int,
                              amount: Int) -> _Flow?
        {
            if start == graph.sink {
                return _Flow(reversedPath: [start], amount: amount)
            }
            
            let vi = start
            let v = graph.vertices[vi]
            
            let startIndex = startIndices[vi]

            for ei in startIndex..<v.edges.count {
                let e = v.edges[ei]
                guard e.rem > 0,
                    depths[vi] < depths[e.head]
                    else { continue }
                
                guard var flow = _search(
                    graph: graph,
                    start: e.head,
                    amount: min(amount, e.rem)) else { continue }
                
                flow.reversedPath.append(start)
                startIndices[vi] = ei
                return flow
            }
            
            startIndices[vi] = v.edges.count
            return nil
        }
        
        mutating func search(graph: Graph) -> Flow? {
            _search(
                graph: graph,
                start: graph.source,
                amount: .max
                )?.toFlow()
        }
    }
    
    public mutating func dinic() {
        while true {
            var depths: [Int] = vertices.map { (_) in 0 }
            
            guard breadthFirstSearch(depths: &depths) else {
                return
            }
            
            var dfs = DFS(depths: depths)
            
            while true {
                guard let flow = dfs.search(graph: self) else {
                    break
                }
                
                addFlow(flow)
                
                writeImage()
            }
        }
    }
}

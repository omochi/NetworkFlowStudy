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
    
    internal struct DFSFlow {
        var reversedPath: [Int]
        var amount: Int
        
        func toFlow() -> Flow {
            Flow(path: reversedPath.reversed(),
                 amount: amount)
        }
    }
    
    internal func depthFirstSearch(
        start: Int,
        amount: Int,
        depths: [Int]) -> DFSFlow?
    {
        if start == sink {
            return DFSFlow(reversedPath: [start], amount: amount)
        }
        
        let vi = start
        let v = vertices[vi]
        for ei in v.edges.indices {
            let e = v.edges[ei]
            guard e.rem > 0,
                depths[vi] < depths[e.head]
                else { continue }
            
            guard var flow = depthFirstSearch(
                start: e.head,
                amount: min(amount, e.rem),
                depths: depths) else { continue }
            
            flow.reversedPath.append(start)
            
            return flow
        }
        
        return nil
    }
    
    public mutating func dinic() {
        while true {
            var depths: [Int] = vertices.map { (_) in 0 }
            
            guard breadthFirstSearch(depths: &depths) else {
                return
            }
            
            while true {
                guard let flow = depthFirstSearch(
                    start: source,
                    amount: Int.max,
                    depths: depths)
                    else { break }
                
                addFlow(flow.toFlow())
                
                try! imageWriter?.write(graph: toGraphviz())
            }
        }
    }
}

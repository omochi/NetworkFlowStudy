import Basic

extension Graph {
    
    public struct PotentialDijkstra {
        struct VertexInfo: Modifiable {
            var potential: Int
            var cost: Int
            var tail: Int
        }
        
        var infos: [VertexInfo]
        
        init(graph: Graph) {
            infos = graph.vertices.map { (_) in
                VertexInfo(potential: 0,
                           cost: .max,
                           tail: graph.source)
            }
        }
        
        mutating func search(graph: Graph) -> Path? {
            infos = infos.map { (info) in
                var info = info
                info.cost = .max
                info.tail = graph.source
                return info
            }
            
            infos[graph.source].cost = 0
            var founds: [Int] = [graph.source]
            
            func pop() -> Int? {
                guard let best = (founds.enumerated().min { (a, b) in
                    infos[a.element].cost < infos[b.element].cost
                }) else { return nil }
                
                founds.remove(at: best.offset)
                
                return best.element
            }
            
            while let vi = pop() {
                let v = graph.vertices[vi]
                
                for e in v.edges {
                    guard e.remainder > 0 else { continue }
                    
                    let cost = infos[vi].cost + e.cost +
                        infos[e.head].potential - infos[vi].potential
                    
                    guard cost < infos[e.head].cost else { continue }
                    
                    infos[e.head].modify { (info) in
                        info.cost = cost
                        info.tail = vi
                    }
                    
                    if !founds.contains(e.head) {
                        founds.append(e.head)
                    }
                }
            }
            
            if infos[graph.sink].cost == .max {
                return nil
            }
            
            for vi in graph.vertices.indices {
                infos[vi].modify { (info) in
                    if info.cost != .max {
                        info.potential -= info.cost
                    }
                }
            }
            
            var revPath: [Int] = []
            var i = graph.sink
            while true {
                revPath.append(i)
                if i == graph.source { break }
                i = infos[i].tail
            }
            
            return revPath.reversed().map { $0 }
        }
    }
    
    public mutating func primalDual2(amount: Int) {
        writeImage()
        var amount = amount
        var pd = PotentialDijkstra(graph: self)
        while true {
            guard let path = pd.search(graph: self) else { break }
            let flow = min(remainder(of: path), amount)
            guard flow > 0 else { break }
            addFlow(path: path, amount: flow)
            amount -= flow
            writeImage()
        }
    }
}

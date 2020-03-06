import Basic

extension Graph {
    public func bellmanFord() -> Path? {
        struct VertexInfo: Modifiable {
            var cost: Int
            var tail: Int
        }
        
        var infos = vertices.map { (_) in VertexInfo(cost: .max, tail: source) }
        
        infos[source].cost = 0
        
        for _ in 0..<(vertices.count - 1) {
            for vi in vertices.indices {
                if infos[vi].cost == .max { continue }

                let v = vertices[vi]
                
                for e in v.edges {
                    guard e.remainder > 0 else { continue }
                
                    let cost = infos[vi].cost + e.cost
                    if cost < infos[e.head].cost {
                        infos[e.head].modify { (info) in
                            info.cost = cost
                            info.tail = vi
                        }
                    }
                }
            }
        }
        
        if infos[sink].cost == .max {
            return nil
        }
        
        var revPath: [Int] = []
        
        var i = sink
        while true {
            revPath.append(i)
            if i == source { break }
            i = infos[i].tail
        }
        
        return revPath.reversed().map { $0 }
    }
    
    public mutating func primalDual(amount: Int) {
        writeImage()
        
        var amount = amount
        while true {
            guard let path = bellmanFord() else { break }
            let flow = min(remainder(of: path), amount)
            guard flow > 0 else { break }
            addFlow(path: path, amount: flow)
            amount -= flow
            writeImage()
        }
    }
}

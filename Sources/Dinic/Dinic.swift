import EdmondsKarp

extension Graph {
    internal func breadthFirstSearch(depths: inout [Int]) -> Bool {
        struct VertexInfo {
            var isFound: Bool = false
            var tail: Int?
        }
        
        var infos = vertices.map { (_) in VertexInfo() }
        var nexts: [Int] = [source]
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
                 nexts.append(v)
                
                depths[v] = depths[current] + 1
            }
        }
    }
    
//    internal func depthFirstSearch(
//        start: Int,
//        capacity: Int)
    
    public mutating func dinic() {
        var depths: [Int] = vertices.map { (_) in 0 }
        
        while true {
            guard breadthFirstSearch(depths: &depths) else {
                return
            }
        }
    }
}

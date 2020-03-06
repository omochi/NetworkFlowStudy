import Basic
import Graphviz

extension Graph {
    internal func breadthFirstSearch() -> Flow? {
        struct VertexInfo {
            var isFound: Bool = false
            var tail: Int?
            var capacity: Int = .max
        }
        
        var infos = vertices.map { (_) in VertexInfo() }
        var nexts: [Int] = [source]
        infos[source].isFound = true
        
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

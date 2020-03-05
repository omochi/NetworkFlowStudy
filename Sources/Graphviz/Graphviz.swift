import Foundation

public struct VGraph: CustomStringConvertible {
    public var name: String
    public var nodes: [VNode]
    public var edges: [VEdge]
    
    public init(name: String) {
        self.name = name
        self.nodes = []
        self.edges = []
    }
    
    public var description: String {
        var b = TextBuilder()

        b.write("digraph \(name) {")
        b.nest { (b) in
            b.write("graph [")
            b.nest { (b) in
                b.write("charset = \"UTF-8\";")
            }
            b.write("];")
            
            for node in nodes {
                b.write("\(node.name);")
            }
            
            for edge in edges {
                b.write("\(edge.source) -> \(edge.sink) [")
                b.nest { (b) in
                    b.write("label = \"\(edge.label)\"")                    
                }
                b.write("];")
            }
        }
        b.write("}")
        
        return b.text
    }
    
}

public struct VNode {
    public var name: String
    public init(name: String) {
        self.name = name
    }
}

public struct VEdge {
    public var source: String
    public var sink: String
    public var label: String
    
    public init(source: String,
                sink: String,
                label: String)
    {
        self.source = source
        self.sink = sink
        self.label = label
    }
}

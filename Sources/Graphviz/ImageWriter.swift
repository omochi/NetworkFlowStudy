import Foundation
import Basic

func execute(_ command: [String]) throws {
    let p = Process()
    p.executableURL = URL(fileURLWithPath: command[0])
    p.arguments = Array(command[1...])
    p.launch()
    p.waitUntilExit()
    
    guard p.terminationStatus == EXIT_SUCCESS else {
        throw MessageError("status=\(p.terminationStatus), command=\(command)")
    }
}


public final class ImageWriter {
    private let directory: URL
    private var counter: Int
    
    public static let `default` = ImageWriter(
        directory: fm.temporaryDirectory
            .appendingPathComponent(Randoms.randomString(length: 12))
    )
    
    public init(directory: URL) {
        self.directory = directory
        self.counter = 0
    }
    
    public func write(graph: VGraph) throws {
        let file = directory
            .appendingPathComponent(String(format: "%03d.png", counter))
        
        try fm.createDirectory(at: directory, withIntermediateDirectories: true)
        
        let textFile = directory
            .appendingPathComponent(Randoms.randomString(length: 12) + ".txt")
        let text = graph.description
        try text.write(to: textFile, atomically: true, encoding: .utf8)
        
        try execute(["/usr/local/bin/dot", "-Tpng",
                     "-o" + file.path,
                     textFile.path])
        
        print("image: \(file.path)")
        
        try? fm.removeItem(at: textFile)
        
        counter += 1
    }
}

import Foundation

struct ProcessRow: Identifiable {
    let pid: Int32
    let cpu: Double
    let memoryKB: Int
    let name: String

    var id: Int32 { pid }

    /// Parses a line of `ps -o pid=,pcpu=,rss=,comm=`; the name may contain spaces.
    init?(psLine: Substring) {
        let fields = psLine.split(separator: " ", maxSplits: 3)
        guard fields.count == 4,
              let pid = Int32(fields[0]),
              let cpu = Double(fields[1]),
              let memoryKB = Int(fields[2]) else { return nil }

        self.pid = pid
        self.cpu = cpu
        self.memoryKB = memoryKB
        self.name = fields[3].trimmingCharacters(in: .whitespaces)
    }
}

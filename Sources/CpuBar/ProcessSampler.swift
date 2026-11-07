import Foundation

@MainActor
final class ProcessSampler: ObservableObject {
    @Published private(set) var topProcesses: [ProcessRow] = []
    @Published private(set) var totalCpu = 0

    private let displayedCount = 8
    private let refreshInterval: TimeInterval = 3
    private var timer: Timer?

    init() {
        refresh()
        timer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.refresh() }
        }
    }

    func refresh() {
        let processes = readProcessesSortedByCpu()
        let cpuSum = processes.reduce(0) { $0 + $1.cpu }
        let coreCount = Double(ProcessInfo.processInfo.activeProcessorCount)

        totalCpu = Int(cpuSum / coreCount)
        topProcesses = Array(processes.prefix(displayedCount))
    }

    private func readProcessesSortedByCpu() -> [ProcessRow] {
        let ps = Process()
        ps.executableURL = URL(fileURLWithPath: "/bin/ps")
        ps.arguments = ["-A", "-c", "-r", "-o", "pid=,pcpu=,rss=,comm="]
        // Forces a dot as decimal separator whatever the user locale.
        ps.environment = ["LC_ALL": "C"]

        let pipe = Pipe()
        ps.standardOutput = pipe

        do {
            try ps.run()
        } catch {
            return []
        }

        let output = pipe.fileHandleForReading.readDataToEndOfFile()
        ps.waitUntilExit()

        return String(decoding: output, as: UTF8.self)
            .split(separator: "\n")
            .compactMap(ProcessRow.init(psLine:))
    }
}

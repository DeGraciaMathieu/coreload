import SwiftUI

struct ProcessListView: View {
    @ObservedObject var sampler: ProcessSampler
    @State private var pidPendingStop: Int32?
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 6) {
                GridRow {
                    Text("Processus")
                    Text("PID")
                    Text("CPU")
                    Text("Mémoire")
                    Text("")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize()

                ForEach(sampler.topProcesses) { process in
                    GridRow {
                        Text(process.name)
                            .lineLimit(1)
                            .truncationMode(.middle)
                            .frame(width: 200, alignment: .leading)
                        Text(String(process.pid))
                        Text(coreUsage(of: process))
                            .foregroundStyle(loadColor(of: process))
                        Text("\(process.memoryKB / 1024) Mo")
                        stopButton(for: process)
                    }
                    .monospacedDigit()
                    .fixedSize()
                }
            }

            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            Divider()

            Button("Quitter CpuBar") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(12)
    }

    /// `ps` reports CPU as a percentage of one core: 100 % means one full core.
    private func coreUsage(of process: ProcessRow) -> String {
        let cores = process.cpu / 100
        let unit = cores >= 2 ? "cœurs" : "cœur"

        return String(format: "%.2f \(unit)", locale: Locale(identifier: "fr_FR"), cores)
    }

    private func loadColor(of process: ProcessRow) -> Color {
        let cores = process.cpu / 100

        if cores >= 1 { return .red }
        if cores >= 0.5 { return .orange }
        return .primary
    }

    @ViewBuilder
    private func stopButton(for process: ProcessRow) -> some View {
        if pidPendingStop == process.pid {
            Button("Confirmer") { stop(process) }
                .tint(.red)
        } else {
            Button("Arrêter") {
                pidPendingStop = process.pid
                errorMessage = nil
            }
        }
    }

    private func stop(_ process: ProcessRow) {
        pidPendingStop = nil

        if kill(process.pid, SIGTERM) != 0 {
            let reason = String(cString: strerror(errno))
            errorMessage = "Impossible d'arrêter \(process.name) : \(reason)"
        }

        sampler.refresh()
    }
}

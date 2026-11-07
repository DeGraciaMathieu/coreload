import SwiftUI

@main
struct CpuBarApp: App {
    @StateObject private var sampler = ProcessSampler()

    var body: some Scene {
        MenuBarExtra {
            ProcessListView(sampler: sampler)
        } label: {
            Text("CPU \(sampler.totalCpu)%")
        }
        .menuBarExtraStyle(.window)
    }
}

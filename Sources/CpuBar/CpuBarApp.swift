import SwiftUI

@main
struct CpuBarApp: App {
    @StateObject private var sampler = ProcessSampler()

    var body: some Scene {
        MenuBarExtra {
            ProcessListView(sampler: sampler)
        } label: {
            Image(nsImage: MenuBarLabel.image(totalCpu: sampler.totalCpu))
        }
        .menuBarExtraStyle(.window)
    }
}

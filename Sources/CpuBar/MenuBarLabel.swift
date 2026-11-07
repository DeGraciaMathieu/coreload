import SwiftUI

/// The menu bar ignores most modifiers on a text label, so the label is drawn as a template image
/// with a constant width: going from "CPU 9%" to "CPU 10%" no longer shifts the other menu bar items.
@MainActor
enum MenuBarLabel {
    static func image(totalCpu: Int) -> NSImage {
        let renderer = ImageRenderer(content: MenuBarLabelContent(totalCpu: totalCpu))
        renderer.scale = NSScreen.main?.backingScaleFactor ?? 2

        let image = renderer.nsImage ?? NSImage()
        // Template: macOS tints it to match a light or dark menu bar.
        image.isTemplate = true
        return image
    }
}

private struct MenuBarLabelContent: View {
    let totalCpu: Int

    var body: some View {
        ZStack(alignment: .leading) {
            // Reserves the width of the widest value.
            Text("CPU 100%")
                .hidden()
            Text("CPU \(totalCpu)%")
        }
        .monospacedDigit()
        .font(.system(size: NSFont.menuBarFont(ofSize: 0).pointSize))
    }
}

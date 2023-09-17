import Cocoa
import Foundation

NSLog("Starting app...")

var window = NSWindow.init(
	contentRect: NSMakeRect(0, 0, 400, 240),
	styleMask: .titled,
	backing: .buffered,
	defer: false
)

window.cascadeTopLeft(from: NSMakePoint(20, 20))
window.makeKeyAndOrderFront(.none)
window.title = "McKayla"

NSApp.setActivationPolicy(.regular)
NSApp.activate(ignoringOtherApps: true)
NSApp.run()

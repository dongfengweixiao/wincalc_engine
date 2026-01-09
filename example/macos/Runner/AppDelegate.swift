import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  override func applicationDidFinishLaunching(_ notification: Notification) {
    // This is required for windowManager to work
    let window = mainFlutterWindow as? NSWindow
    window?.titleVisibility = .hidden
    window?.titlebarAppearsTransparent = true
    
    super.applicationDidFinishLaunching(notification)
  }
}

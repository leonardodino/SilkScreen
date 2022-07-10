import Cocoa

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let welcomeWindowController = DocumentWindowController(document: nil)
    private weak var welcomeWindow: NSWindow? { welcomeWindowController.window }
    private weak var imageView: GPImageView? { NSApp.mainWindow?.contentView as? GPImageView }
    
    @objc dynamic var retinaMenuItemState: NSControl.StateValue = .mixed {
        didSet {
            guard retinaMenuItemState != .mixed else { return }
            imageView?.retina = retinaMenuItemState.isOn
        }
    }

    func applicationDidUpdate(_ notification: Notification) {
        retinaMenuItemState.set({
            guard let imageView = imageView else { return .mixed }
            return imageView.retina ? .on : .off
        }())
    }

    @objc func newDocument(_ sender: Any?) {
        welcomeWindow?.makeKeyAndOrderFront(self)
    }

    override func responds(to selector: Selector!) -> Bool {
        if selector == #selector(newDocument(_:)) {
            if (welcomeWindow?.isVisible == true) { return false }
            return applicationShouldOpenUntitledFile(NSApp)
        }
        return super.responds(to: selector)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
        welcomeWindow?.makeKeyAndOrderFront(self)
    }

    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        let documentWindows = sender.windows.filter { $0 is DocumentWindow && $0 != welcomeWindow }
        return documentWindows.isEmpty
    }

    func applicationOpenUntitledFile(_ sender: NSApplication) -> Bool {
        welcomeWindow?.makeKeyAndOrderFront(self)
        return welcomeWindow != nil
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return false
    }
}

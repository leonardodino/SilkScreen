import Cocoa

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    lazy var windowController: WindowController = { WindowController(document: nil) }()
    private var window: Window { windowController.window as! Window }
    private weak var imageView: GPImageView? { window.contentView as? GPImageView }
    
    @objc dynamic var retinaMenuItemState: NSControl.StateValue = .mixed {
        didSet {
            guard retinaMenuItemState != .mixed else { return }
            guard imageView?.retina != retinaMenuItemState.isOn else { return }
            imageView?.retina = retinaMenuItemState.isOn
        }
    }

    func applicationDidUpdate(_ notification: Notification) {
        retinaMenuItemState.set(imageView.map{ $0.retina ? .on : .off } ?? .mixed)
    }

    @objc func newDocument(_ sender: Any?) {
        windowController.update(withDocument: nil)
        window.makeKeyAndOrderFront(self)
    }

    override func responds(to selector: Selector!) -> Bool {
        if selector == #selector(newDocument(_:)) {
            return window.hasDocument || !window.isVisible
        }
        return super.responds(to: selector)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
        window.makeKeyAndOrderFront(self)
    }

    func applicationOpenUntitledFile(_ sender: NSApplication) -> Bool {
        newDocument(self)
        return true
    }
}

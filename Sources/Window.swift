import Cocoa

class Window: NSWindow {
    override class var allowsAutomaticWindowTabbing: Bool { get { return false } set {} }
    var hasDocument = false

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: [.borderless, .miniaturizable, .closable], backing: backingStoreType, defer: flag)
        self.isOpaque = false
        self.isMovable = true
        self.isRestorable = false
        self.isDocumentEdited = false
        self.showsResizeIndicator = false
        self.isMovableByWindowBackground = true
        self.collectionBehavior = [.fullScreenNone, .managed]
        self.updateStyle()
    }

    override var title: String {
        get {
            let filename = (windowController?.document as? Document)?.fileURL?.lastPathComponent
            return filename ?? Bundle.main.displayName!
        }
        set {}
    }

    convenience init() {
        self.init(contentViewController: ViewController(document: nil))
    }

    override var isZoomable: Bool { return false }
    override var isResizable: Bool { return false }
    override var canBecomeKey: Bool { return true }
    override var canBecomeMain: Bool { return true }
    override var firstResponder: NSResponder? { return windowController }
    override func makeKeyAndOrderFront(_ sender: Any?) {
        NSApp.removeWindowsItem(self)
        super.makeKeyAndOrderFront(sender)
        NSApp.addWindowsItem(self, title: title, filename: false)
    }

    private func updateStyle() {
        if self.hasDocument {
            self.backgroundColor = .clear
            self.level = .floating
            self.hasShadow = false

            // hack: removing shadow leaves it on screen
            // force window to redraw to get rid of glitch
            self.orderOut(self)
            DispatchQueue.main.async { self.orderFront(self) }
        } else {
            self.alphaValue = 1
            self.backgroundColor = .windowBackgroundColor
            self.level = .normal
            self.hasShadow = true
        }
    }
    
    func update(withDocument document: Document?) {
        self.hasDocument = document != nil
        self.willChangeValue(for: \.title)
        self.contentViewController = ViewController(document: document)
        self.didChangeValue(for: \.title)
        NSApp.changeWindowsItem(self, title: title, filename: false)
        self.updateStyle()
    }
}

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

    private func updateStyle() {
        if self.hasDocument {
            self.backgroundColor = .clear
            self.level = .floating
        } else {
            self.backgroundColor = .windowBackgroundColor
            self.level = .normal
        }
    }
    
    func update(withDocument document: Document?) {
        self.hasDocument = document != nil
        self.willChangeValue(for: \.title)
        self.contentViewController = ViewController(document: document)
        self.didChangeValue(for: \.title)
        self.updateStyle()
    }
}

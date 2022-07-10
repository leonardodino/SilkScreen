import Cocoa

class Window: NSWindow {
    var hasDocument = false

    convenience init() {
        self.init(contentViewController: ViewController(document: nil))

        self.isOpaque = false
        self.isMovable = true
        self.isDocumentEdited = false
        self.isMovableByWindowBackground = true
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.isRestorable = false
        self.tabbingMode = .disallowed

        self.showsResizeIndicator = false
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true
        self.styleMask.formUnion(.fullSizeContentView)
        self.styleMask.remove(.resizable)
        // borderless advantages: square borders, no need to hide buttons
        // borderless issues: breaks default close/minimize/window menu/etc
        // self.styleMask = [.borderless]

        self.updateStyle()
    }
    
    private func updateStyle() {
        if hasDocument {
            self.standardWindowButton(.closeButton)?.isHidden = true
            self.backgroundColor = .clear
            self.level = .floating
            self.collectionBehavior = [.fullScreenNone, .managed]
        } else {
            self.standardWindowButton(.closeButton)?.isHidden = false
            self.backgroundColor = .windowBackgroundColor
            self.level = .normal
            self.collectionBehavior = []
        }
    }
    
    func update(withDocument document: Document?) {
        hasDocument = document != nil
        self.updateStyle()
        self.contentViewController = ViewController(document: document)
    }
    
    override var isZoomable: Bool {return false}
    override var isResizable: Bool {return false}
}

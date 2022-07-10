import Cocoa

class DocumentWindow: NSWindow {
    convenience init(document: Document?){
        self.init(contentViewController: ViewController(document: document))

        self.isOpaque = false
        self.isMovable = true
        self.isDocumentEdited = false
        self.isMovableByWindowBackground = true
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.isRestorable = false
        self.tabbingMode = .disallowed

        self.showsResizeIndicator = false
        self.standardWindowButton(.closeButton)?.isHidden = document != nil
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true
        self.styleMask.formUnion(.fullSizeContentView)
        self.styleMask.remove(.resizable)
        
        
        if document != nil {
            self.backgroundColor = .clear
            self.level = .floating
            self.collectionBehavior = [.fullScreenNone, .managed]
        }
        
        // borderless advantages: square borders, no need to hide buttons
        // borderless issues: breaks default close/minimize/window menu/etc
        // self.styleMask = [.borderless]
    }
    
    override var isZoomable: Bool {return false}
}

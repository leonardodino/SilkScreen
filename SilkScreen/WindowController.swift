import Cocoa

class DocumentWindowController: NSWindowController, NSWindowDelegate {
    convenience init(document: Document?) {
        self.init(window: DocumentWindow(document: document))
        self.window!.delegate = self
    }

    override func scrollWheel(with event: NSEvent) {
        guard let alphaValue = self.window?.alphaValue else { return }
        
        var newAlpha = alphaValue + (event.deltaY/50)
        if (newAlpha > 1) {newAlpha = 1}
        if (newAlpha < 0.1) {newAlpha = 0.1}
        self.window?.alphaValue = newAlpha
    }
    
    override var shouldCloseDocument: Bool { set {} get { return true } }
    
    func windowDidBecomeMain(_ notification: Notification) {
        window?.ignoresMouseEvents = false
    }

    func windowDidResignMain(_ notification: Notification) {
        if (contentViewController as? ViewController)?.document != nil {
            window?.ignoresMouseEvents = true
        }
    }
}

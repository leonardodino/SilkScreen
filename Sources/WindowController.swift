import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {
    var previousAlpha: CGFloat = 1

    convenience init(document: Document?) {
        self.init(window: Window())
        self.shouldCloseDocument = true
        self.window!.delegate = self
    }

    override func scrollWheel(with event: NSEvent) {
        guard let window = self.window else { return }
        let nextAlpha = window.alphaValue + (event.deltaY/50)
        window.alphaValue = nextAlpha.clamped(to: 0.1...1)
    }

    @objc func performClose(_ sender: Any) {
        self.window?.close()
    }

    @objc func performMiniaturize(_ sender: Any) {
        self.window?.miniaturize(sender)
    }

    @objc func paste(_ sender: Any) {
        if let fileURL = NSPasteboard.general.getImageFileURL() {
            NSDocumentController.shared.openDocument(withContentsOf: fileURL, display: true){_,_,_ in }
        } else if let imageData = NSPasteboard.general.getImageData() {
            _ = NSDocumentController.shared.openDocumentFromData(imageData, ofType: "public.image")
        }
    }

    override func responds(to selector: Selector!) -> Bool {
        if selector == #selector(paste(_:)) {
            return NSPasteboard.general.hasImageFileURL() || NSPasteboard.general.hasImageData()
        }
        return super.responds(to: selector)
    }

    func update(withDocument document: Document?) {
        if document == nil && self.document == nil { return }
        guard let window = window as? Window else { return }

        if let previous = self.document as? NSDocument {
            previous.removeWindowController(self)
            previous.close()
        }

        document?.addWindowController(self)
        window.update(withDocument: document)
    }
    
    func windowDidBecomeMain(_ notification: Notification) {
        window?.ignoresMouseEvents = false
    }

    func windowDidResignMain(_ notification: Notification) {
        if (contentViewController as? ViewController)?.document != nil {
            window?.ignoresMouseEvents = true
        }
    }

    func windowWillMiniaturize(_ notification: Notification) {
        guard let window = window else { return }
        self.previousAlpha = window.alphaValue
        window.alphaValue = 1
    }

    func windowDidDeminiaturize(_ notification: Notification) {
        guard let window = window else { return }
        window.invalidateShadow()
        DispatchQueue.main.async { window.alphaValue = self.previousAlpha }
    }

    func windowWillClose(_ notification: Notification) {
        update(withDocument: nil)
    }
}

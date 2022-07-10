import Cocoa

class Document: NSDocument {
    var image: NSImage?
    var retina = false
    
    override class var autosavesInPlace: Bool { return false }
    override class var autosavesDrafts: Bool { return false }
    override var isDocumentEdited: Bool { return false }
    
    override func makeWindowControllers() {
        NSApp.windows.forEach { ($0 as? DocumentWindow)?.close() }
        self.addWindowController(DocumentWindowController(document: self))
    }
    
    override func data(ofType typeName: String) throws -> Data {
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        guard let image = NSImage(data: data) else { throw CocoaError(.fileReadCorruptFile) }
        if (image.isValid != true) { throw CocoaError(.fileReadCorruptFile) }
        if (image.size.shorterSideIsLess(than: 2)) { throw CocoaError(.fileReadCorruptFile) }

        self.image = image
        self.retina = fileURL?.representsRetinaImage ?? false
    }
}


import Cocoa

final class BaseImageView: NSImageView {
    // disable native NSImage Drop behaviour
    override func registerForDraggedTypes(_ newTypes: [NSPasteboard.PasteboardType]) {}

    // disable native NSImage Drag behavior
    override var mouseDownCanMoveWindow: Bool {return true}

    override var translatesAutoresizingMaskIntoConstraints: Bool { set {} get {return false} }
}

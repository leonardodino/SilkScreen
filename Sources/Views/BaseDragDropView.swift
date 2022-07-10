import Cocoa

class BaseDragDropView: NSView {
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let options: [NSPasteboard.ReadingOptionKey: Any] = [.urlReadingContentsConformToTypes: ["public.image"], .urlReadingFileURLsOnly: true]
        let isValidDragObject = sender.draggingPasteboard.canReadObject(forClasses: [NSURL.self], options: options)
        return isValidDragObject ? NSDragOperation.copy : []
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        super.performDragOperation(sender)
        if sender.draggingPasteboard.types?.contains(.fileURL) == true {
            guard let fileUrlString = sender.draggingPasteboard.propertyList(forType: .fileURL) as? String else { return false }
            guard let fileUrl = URL(string: fileUrlString) else { return false }
            guard fileUrl.isFileURL == true else {return false}
            NSDocumentController.shared.openDocument(withContentsOf: fileUrl, display: true){_,_,_ in }
            return true
        }
        return false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.registerForDraggedTypes([.fileURL])
    }
}

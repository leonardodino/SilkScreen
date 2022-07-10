import Cocoa

final class ViewController: NSViewController {
    weak var document: Document? { return representedObject as? Document }
    
    @objc func toggleRetina(_ sender: Any) {}

    override func responds(to selector: Selector!) -> Bool {
        if document == nil && selector == #selector(toggleRetina(_:)) { return false }
        return super.responds(to: selector)
    }
    
    convenience init(document: Document?) {
        self.init()
        representedObject = document
    }

    override func loadView() {
        if let doc = document, let img = doc.image {
            view = GPImageView(image: img, retina: doc.retina)
        } else {
            view = GPWelcomeView()
        }
    }
}

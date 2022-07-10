import Cocoa

final class GPImageView: BaseDragDropView {
    private let image: NSImage
    private let pixelSize1x: NSSize
    private let pixelSize2x: NSSize

    var retina: Bool {
        didSet {
            guard let window = window else {return}
            image.size = retina ? pixelSize2x : pixelSize1x
            window.setContentSize(image.size)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(image: NSImage, retina: Bool) {
        self.image = image
        self.retina = retina

        guard let rep = image.representations.first else {
            fatalError("could not get image representation")
        }
        pixelSize1x = NSSize(width: rep.pixelsWide, height: rep.pixelsHigh)
        pixelSize2x = pixelSize1x.multiply(0.5)
        
        super.init(frame: NSMakeRect(0.0, 0.0, image.size.width, image.size.height))
    }

    override func draw(_ dirtyRect: NSRect) {
        image.draw(in: bounds)
    }
}

import Cocoa

final class GPWelcomeView: BaseDragDropView {
    private lazy var closeButton: NSView = {
        let size: CGFloat = 11
        let margin = 10

        let image = NSImage(systemSymbolName: "xmark", accessibilityDescription: nil)!
            .withSymbolConfiguration(.init(pointSize: size, weight: .bold))!
        let action = #selector(NSWindow.performClose(_:))
        let view = NSButton(image: image, target: window, action: action)
        view.setAccessibilityLabel("Close window")
        view.isBordered = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setFrameOrigin(.init(x: 0 + margin, y: Int(frame.height - image.size.height) - margin))
        return view
    }()

    private lazy var iconImageView: NSView = {
        let view = BaseImageView(image:
            NSImage(systemSymbolName: "arrow.down.circle", accessibilityDescription: nil)!
                .withSymbolConfiguration(.init(pointSize: 64, weight: .thin, scale: .large))!
        )
        view.contentTintColor = .windowFrameTextColor
        return view
    }()

    private lazy var titleTextView: NSView = {
        let view = NSTextField(labelWithString: "Drop a Mockup")
        view.textColor = .windowFrameTextColor
        view.font = NSFont.preferredFont(forTextStyle: .largeTitle)
        return view
    }()

    private lazy var captionTextView: NSView = {
        let view = NSTextField(labelWithString: "Scroll to set opacity")
        view.textColor = .windowFrameTextColor
        view.alphaValue = 0.5
        view.font = NSFont.preferredFont(forTextStyle: .body)
        view.heightAnchor.constraint(equalToConstant: view.frame.height + 14).isActive = true
        return view
    }()

    private lazy var stackView: NSView = {
        let view  = NSStackView(frame: self.frame)
        view.setViews([iconImageView, titleTextView], in: .center)
        view.setViews([captionTextView], in: .bottom)
        view.orientation = .vertical
        view.spacing = 32
        return view
    }()

    convenience init() {
        self.init(frame: NSMakeRect(0.0, 0.0, 480, 400))
        self.addSubview(closeButton)
        self.addSubview(stackView)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

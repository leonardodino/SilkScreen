import Cocoa

fileprivate func BasicLink(
    text: String,
    href: String,
    font: NSFont
) -> NSAttributedString {
    return NSAttributedString(
        string: text,
        attributes: [
            .font: font,
            .link: NSURL(string: href) ?? "",
            .toolTip: href,
            .underlineColor: NSColor.clear,
        ]
    )
}

fileprivate func join(_ parts: [NSAttributedString]) -> NSMutableAttributedString {
    let joinedString = NSMutableAttributedString(string: "")
    parts.forEach{ joinedString.append($0) }
    return joinedString
}

extension NSApplication.AboutPanelOptionKey {
    static let copyright = NSApplication.AboutPanelOptionKey(rawValue: "Copyright")
}

class AboutWindow {
    static let shared = AboutWindow()
    @objc func show() {
        NSApp.orderFrontStandardAboutPanel(options: [
            .copyright: "",
            .credits: join([
                BasicLink(
                    text: "Source Code",
                    href: "https://github.com/leonardodino/SilkScreen",
                    font: NSFont.systemFont(ofSize: 12, weight: .medium)
                ),
                NSAttributedString(
                    string: "\n\n",
                    attributes: [.font: NSFont.systemFont(ofSize: 6)]
                ),
                BasicLink(
                    text: "Leonardo Dino",
                    href: "https://leonardodino.com/",
                    font: NSFont.systemFont(ofSize: 10)
                ),
            ]),
        ])
        NSApp.activate(ignoringOtherApps: true)
    }
}

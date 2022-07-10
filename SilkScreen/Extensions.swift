import Cocoa
import UniformTypeIdentifiers

extension NSControl.StateValue {
    var isOn: Bool { return self == .on }

    mutating func set(_ newValue: NSControl.StateValue){
        if (self != newValue) {self = newValue}
    }
}

extension URL {
    private var isImageFileURL: Bool {
        guard self.isFileURL else { return false }
        guard let resourceValues = try? self.resourceValues(forKeys: [.contentTypeKey, .fileResourceTypeKey]) else { return false }
        if let contentType = resourceValues.contentType, let fileResourceType = resourceValues.fileResourceType {
            return fileResourceType == .regular && contentType.isSubtype(of: .image)
        }
        return false
    }

    private var isRetinaByFileSuffix: Bool {
        return self.deletingPathExtension().lastPathComponent.hasSuffix("@2x")
    }

    var representsRetinaImage: Bool {
        guard self.isImageFileURL else { return false }
        if (self.isRetinaByFileSuffix) { return true }
        guard let source = CGImageSourceCreateWithURL(self as CFURL, nil) else { return false }
        guard let DPI = try? source.getDPI() else { return false }
        return DPI > 120
    }
}

extension Dictionary {
    func getKeyValue<T>(key: CFString) -> T? {
        guard let dictionary = self as? Dictionary<String, Any> else { return nil }
        guard let value = dictionary[(key as String)] as? T else { return nil }
        if value as? NSObject == kCFNull { return nil }
        return value
    }
}

extension CGImageSource {
    public enum Error: Swift.Error, Equatable {
        case cannotCopyPropertiesAtIndexZero
        case unwrappedPropertyHasMismatchedType
    }

    func getDPI() throws -> Int {
        let options = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let properties = CGImageSourceCopyPropertiesAtIndex(self, 0, options) as? [String: Any] else { throw Error.cannotCopyPropertiesAtIndexZero }
        guard let DPIHeight: NSNumber = properties.getKeyValue(key: kCGImagePropertyDPIHeight) else { throw Error.unwrappedPropertyHasMismatchedType }
        return Int(truncating: DPIHeight)
    }
}

extension NSSize {
    func multiply(_ factor: CGFloat) -> NSSize {
      return NSSize(width: width * factor, height: height * factor)
    }

    func shorterSideIsLess(than dimension: CGFloat) -> Bool {
        return height.isLess(than: dimension) || width.isLess(than: dimension)
    }
}

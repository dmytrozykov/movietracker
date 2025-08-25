import Foundation

extension Locale {
    var serverIdentifier: String {
        identifier.replacingOccurrences(of: "_", with: "-")
    }
}

import UIKit

// MARK: - ImageCacheProtocol

/// A protocol defining a cache for storing and retrieving `UIImage` objects.
///
/// Conforming types must provide an object-safe key type (`AnyObject`)
/// and implement methods to set and retrieve images by key.
protocol ImageCacheProtocol: Sendable {
    /// The type used as a key for caching images.
    /// Must be a reference type (`AnyObject`) to be compatible with `NSCache`.
    associatedtype Key: AnyObject

    /// Stores an image in the cache for the specified key.
    ///
    /// - Parameters:
    ///   - image: The image to cache.
    ///   - key: The key associated with the cached image.
    func setImage(_ image: UIImage, forKey key: Key)

    /// Retrieves an image from the cache.
    ///
    /// - Parameter key: The key associated with the cached image.
    /// - Returns: The cached image if it exists, or `nil` if not found.
    func image(forKey key: Key) -> UIImage?
}

// MARK: - ImageCache

/// A thread-safe in-memory image cache based on `NSCache`.
///
/// This implementation conforms to `ImageCacheProtocol` and provides a wrapper
/// around `NSCache`, which is already thread-safe by design.
/// The class is marked `@unchecked Sendable` because `NSCache` is not
/// statically `Sendable`, but is safe for concurrent use.
final class ImageCache<Key: AnyObject>: ImageCacheProtocol, @unchecked Sendable {
    private let cache = NSCache<Key, UIImage>()

    /// Stores an image in the cache for the specified key.
    ///
    /// - Parameters:
    ///   - image: The image to cache.
    ///   - key: The key associated with the cached image.
    func setImage(_ image: UIImage, forKey key: Key) {
        cache.setObject(image, forKey: key)
    }

    /// Retrieves an image from the cache.
    ///
    /// - Parameter key: The key associated with the cached image.
    /// - Returns: The cached image if it exists, or `nil` if not found.
    func image(forKey key: Key) -> UIImage? {
        cache.object(forKey: key)
    }
}

import UIKit

// MARK: - ImageServiceProtocol

/// A protocol defining an asynchronous service for loading images.
///
/// Conforming types must provide an implementation that fetches images,
/// potentially involving caching or network operations.
protocol ImageServiceProtocol {
    /// Loads an image from a given URL string.
    ///
    /// - Parameter urlString: The string representation of the image URL.
    /// - Returns: The loaded `UIImage` if successful, otherwise `nil`.
    func loadImage(from urlString: String) async -> UIImage?
}

// MARK: - ImageService

/// An `actor` responsible for downloading and caching images.
///
/// - Uses an in-memory cache (`ImageCache`) to store images by URL string.
/// - Ensures thread-safety through actor isolation.
/// - Prevents duplicate downloads by reusing in-progress tasks for the same URL.
actor ImageService: ImageServiceProtocol {
    static let shared = ImageService()

    private let cache = ImageCache<NSString>()
    private var tasks: [String: Task<UIImage?, Never>] = [:]

    /// Loads an image from a given URL string.
    ///
    /// - If the image exists in cache, returns it immediately.
    /// - If a download for the same URL is in progress, awaits its result.
    /// - Otherwise, starts a new download and caches the result.
    ///
    /// - Parameter urlString: The string representation of the image URL.
    /// - Returns: The downloaded `UIImage` if successful, otherwise `nil`.
    func loadImage(from urlString: String) async -> UIImage? {
        if let cachedImage = cache.image(forKey: urlString as NSString) {
            return cachedImage
        }

        if let task = tasks[urlString] {
            return await task.value
        }

        let task = Task { [weak self] () -> UIImage? in
            defer { Task { await self?.removeTask(for: urlString) } }
            guard let self else { return nil }

            guard let data = try? await NetworkService.shared.loadData(from: urlString),
                  let image = UIImage(data: data)
            else {
                return nil
            }

            guard !Task.isCancelled else { return image }

            cache.setImage(image, forKey: urlString as NSString)
            return image
        }

        tasks[urlString] = task
        return await task.value
    }

    private func removeTask(for urlString: String) {
        tasks[urlString] = nil
    }
}

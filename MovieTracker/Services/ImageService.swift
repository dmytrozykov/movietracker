import UIKit

final class ImageService {
    static let shared = ImageService()
    let cache = NSCache<NSString, UIImage>()

    private init() {}

    func loadImage(from urlString: String, headers: [String: String]? = nil) async -> UIImage? {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            return cachedImage
        }

        guard let data = try? await NetworkService.shared.loadData(from: urlString, headers: headers),
              let image = UIImage(data: data)
        else {
            return nil
        }
        cache.setObject(image, forKey: urlString as NSString)
        return image
    }
}

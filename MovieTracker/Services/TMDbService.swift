import UIKit

final class TMDbService {
    static let shared = TMDbService()
    private static let apiKey = Environment.tmdbApiKey

    private init() {}

    private let headers = [
        "Authorization": "Bearer \(apiKey)",
        "accept": "application/json"
    ]

    func fetchPopularMovies(page: Int = 1) async throws -> TMDbResponse {
        let endpoint = Endpoint.MovieList.popular(page: page)
        return try await NetworkService.shared.request(
            endpoint: endpoint,
            headers: headers
        )
    }

    func fetchImage(from path: String, size: TMDbImageSize = .original) async -> UIImage? {
        let endpoint = Endpoint.Image.get(from: path, size: size)
        return await ImageService.shared.loadImage(from: endpoint)
    }
}

extension TMDbService {
    enum Endpoint {
        private static let baseUrl = "https://api.themoviedb.org/3"
    }
}

enum TMDbImageSize: String {
    case w92
    case w154
    case w185
    case w342
    case w500
    case w780
    case original
}

extension TMDbService.Endpoint {
    enum MovieList {
        static let base = "\(baseUrl)/movie"
        static func popular(page: Int) -> String {
            "\(base)/popular?language=\(Locale.current.serverIdentifier)&page=\(page)"
        }
    }

    enum Image {
        static let base = "https://image.tmdb.org/t/p"
        static func get(from path: String, size: TMDbImageSize = .original) -> String {
            "\(base)/\(size.rawValue)\(path)"
        }
    }
}

import Foundation

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
        try await NetworkService.shared.request(
            endpoint: endpoint,
            headers: headers
        )
    }
}

extension TMDbService {
    enum Endpoint {
        private static let baseUrl = "https://api.themoviedb.org/3"
    }
}

extension TMDbService.Endpoint {
    enum MovieList {
        static let base = "\(baseUrl)/movie"
        static func popular(page: Int) -> String {
            "\(base)/popular?language=\(Locale.current.serverIdentifier)&page=\(page)"
        }
    }
}

import UIKit

// MARK: - TMDBServiceProtocol

/// A protocol defining an interface for fetching movie data and images from TMDB (The Movie Database).
protocol TMDBServiceProtocol {
    /// Fetches a paginated list of popular movies from TMDB.
    ///
    /// - Parameter page: The page number to fetch.
    /// - Returns: A `TMDBPopularMovieResponse` containing popular movies and pagination metadata.
    /// - Throws: An error if the network request fails or decoding is unsuccessful.
    func fetchPopularMovies(page: Int) async throws -> TMDBPopularMovieResponse
    
    /// Fetches a movie-related image from TMDB.
    ///
    /// - Parameters:
    ///   - path: The image path returned by the TMDB API (e.g., `/kqjL17yufvn9OVLyXYpvtyrFfak.jpg`).
    ///   - size: The desired image size (e.g., `.w500`, `.original`).
    /// - Returns: The downloaded `UIImage`, or `nil` if the request fails.
    func fetchImage(from path: String, size: TMDBImageSize) async -> UIImage?
}

// MARK: - TMDBService

/// A service responsible for communicating with TMDB (The Movie Database) API.
///
/// - Provides movie-related endpoints such as fetching popular movies.
/// - Handles image fetching from TMDB's image CDN.
/// - Uses `NetworkService` for HTTP requests and `ImageService` for image caching/downloading.
/// - Singleton (`shared`) instance is provided for convenience.
final class TMDBService: TMDBServiceProtocol {
    static let shared = TMDBService()
    
    private static let apiKey = Environment.tmdbApiKey
    
    private static let headers = [
        HTTPHeader.Field.authorization: HTTPHeader.Value.bearer(apiKey: apiKey),
        HTTPHeader.Field.accept: HTTPHeader.Value.json
    ]

    /// Fetches a paginated list of popular movies from TMDB.
    ///
    /// - Parameter page: The page number to fetch (defaults to 1).
    /// - Returns: A `TMDBPopularMovieResponse` containing the results and pagination data.
    /// - Throws: An error if the request fails or decoding is unsuccessful.
    func fetchPopularMovies(page: Int = 1) async throws -> TMDBPopularMovieResponse {
        let endpoint = Endpoint.MovieList.popular(page: page)
        return try await NetworkService.shared.request(
            endpoint: endpoint,
            headers: Self.headers
        )
    }
    
    /// Fetches a movie-related image from TMDB’s image CDN.
    ///
    /// - Parameters:
    ///   - path: The image path provided by TMDB.
    ///   - size: The desired image size (default is `.original`).
    /// - Returns: A `UIImage` if successfully fetched, otherwise `nil`.
    func fetchImage(from path: String, size: TMDBImageSize = .original) async -> UIImage? {
        let endpoint = Endpoint.Image.get(from: path, size: size)
        return await ImageService.shared.loadImage(from: endpoint)
    }
}

// MARK: - TMDBService.Endpoint

// swiftlint:disable nesting
extension TMDBService {
    private enum Endpoint {
        private static let baseUrl = "https://api.themoviedb.org/3"

        enum MovieList {
            static let base = "\(baseUrl)/movie"

            static func popular(page: Int) -> String {
                "\(base)/popular?language=\(Locale.current.bcp47Identifier)&page=\(page)"
            }
        }

        enum Image {
            static let base = "https://image.tmdb.org/t/p"

            static func get(from path: String, size: TMDBImageSize = .original) -> String {
                "\(base)/\(size.rawValue)\(path)"
            }
        }
    }
}

// swiftlint:enable nesting

// MARK: - TMDBImageSize

/// Represents the available TMDB image sizes.
///
/// These correspond directly to TMDB’s documented image size options.
enum TMDBImageSize: String {
    case w92, w154, w185, w342, w500, w780, original
}

import Foundation

/// Strucuture representing details for a specific movie
struct MovieDetails: Codable {
    let id: Int
    let title: String
    let releaseDate: Date?
    let voteAverage: Double
    let posterPath: String?
    let genres: [Genre]
    let runtime: Int?
    let overview: String

    // MARK: - Appended responses

    let credits: MovieCredits?

    // MARK: - Coding

    enum CodingKeys: String, CodingKey {
        case id, title, genres, runtime, overview, credits
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        genres = try container.decode([Genre].self, forKey: .genres)
        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        overview = try container.decode(String.self, forKey: .overview)
        credits = try container.decodeIfPresent(MovieCredits.self, forKey: .credits)

        if let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate),
           !releaseDateString.isEmpty
        {
            releaseDate = DateFormatter.releaseDateFormatter.date(from: releaseDateString)
        } else {
            releaseDate = nil
        }
    }
}

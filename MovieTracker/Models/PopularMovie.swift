import Foundation

/// Structure representing TMDB API movie from "popular" request.
struct PopularMovie: Codable, Hashable, Identifiable {
    let id: Int
    let title: String
    let releaseDate: Date?
    let posterPath: String?
    let voteAverage: Double

    // MARK: - Coding

    private enum CodingKeys: String, CodingKey {
        case id, title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)

        if let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate),
           !releaseDateString.isEmpty
        {
            releaseDate = DateFormatter.releaseDateFormatter.date(from: releaseDateString)
        } else {
            releaseDate = nil
        }
    }
}

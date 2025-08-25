import Foundation

struct Movie: Codable {
    let id: String
    let title: String
    let overview: String
    let releaseDate: Date
    let posterPath: String?
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        
        let releaseDateString = try container.decode(Date.self, forKey: .releaseDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: releaseDateString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .releaseDate
                in: container,
                debugDescription: "Date string does not match format yyyy-MM-dd"
            )
        }
    }
}

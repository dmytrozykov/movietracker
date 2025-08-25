import Foundation

struct Movie: Decodable {
    let id: String
    let title: String
    let overview: String
    let releaseDate: Date
    let posterPath: String
    let voteAverage: Double
}

import Foundation

struct MovieResponse: Decodable {
    let page: Int
    let results: [Movie]
}

extension MovieResponse {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return .formatted(formatter)
    }

    static var decoder: JSONDecoder {
        var decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return decoder
    }
}

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        session = URLSession(configuration: config)
    }

    func request<T: Codable>(
        endpoint: String,
        type: T.Type = T.self,
        method: HttpMethod = .get,
        headers: [String: String]? = nil,
        decoder: JSONDecoder? = nil
    ) async throws -> T {
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            for (key, values) in headers {
                request.setValue(values, forHTTPHeaderField: key)
            }
        }

        let (data, response): (Data, URLResponse)

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.networkUnavailable
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }

        try Self.handleResponse(httpResponse)

        let decoder = decoder ?? JSONDecoder()
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }

    private static func handleResponse(_ httpResponse: HTTPURLResponse) throws {
        switch httpResponse.statusCode {
        case 200 ... 299:
            break
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500 ... 599:
            throw NetworkError.serverError(httpResponse.statusCode)
        default:
            throw NetworkError.serverError(httpResponse.statusCode)
        }
    }
}

extension NetworkService {
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case badRequest // 400
    case unauthorized // 401
    case forbidden // 403
    case notFound // 404
    case serverError(Int) // 500+
    case networkUnavailable // Network connection issues

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("invalid_url_error_description", comment: "Invalid URL error")
        case .noData:
            return NSLocalizedString("no_data_error_description", comment: "No data error")
        case .decodingError:
            return NSLocalizedString("decoding_error_description", comment: "Decoding error")
        case .badRequest:
            return NSLocalizedString("bad_request_error_description", comment: "400 error")
        case .unauthorized:
            return NSLocalizedString("unauthorized_error_description", comment: "401 error")
        case .forbidden:
            return NSLocalizedString("forbidden_error_description", comment: "403 error")
        case .notFound:
            return NSLocalizedString("not_found_error_description", comment: "404 error")
        case let .serverError(code):
            let format = NSLocalizedString("server_error_description", comment: "Server error with code")
            return String(format: format, code)
        case .networkUnavailable:
            return NSLocalizedString("network_unavailable_error_description", comment: "Network error")
        }
    }
}

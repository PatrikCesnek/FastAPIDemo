//
//  APIService.swift
//  FastAPIDemo
//
//  Created by Patrik Cesnek on 07/12/2025.
//

import Foundation

enum APIError: Error, LocalizedError {
    case urlError
    case httpError(Int)
    case decodingError(Error)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .urlError: return "Invalid URL"
        case .httpError(let code): return "HTTP Error: \(code)"
        case .decodingError(let err): return "Decoding error: \(err.localizedDescription)"
        case .unknown(let err): return err.localizedDescription
        }
    }
}

final class APIService {
    static let shared = APIService()

    private let baseURL = URL(string: "http://127.0.0.1:8000")! //TODO: - get rid of force unwrap

    private init() {}

    func fetchPosts() async throws -> [Post] {
        let url = baseURL.appendingPathComponent("/api/posts")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Post].self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    func fetchPost(id: Int) async throws -> Post {
        let url = baseURL.appendingPathComponent("/api/posts/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Post.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    private func validate(response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else { return }
        guard (200...299).contains(http.statusCode) else {
            throw APIError.httpError(http.statusCode)
        }
    }
}


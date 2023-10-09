//
//  APIManager.swift
//  JayneshProject
//
//  Created by Jaynesh Patel on 10/8/23.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
        
    func getMatchData(url: URL) async throws -> MatchData {
      let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }
        
        switch httpResponse.statusCode {
        case 200...299: break
        case 400...499:
            throw APIError.badRequest
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.unknown
        }

        let decoder = JSONDecoder()
        return try decoder.decode(MatchData.self, from: data)
    }
    
}

enum APIError: Error {
    case badRequest
    case serverError
    case unknown
}

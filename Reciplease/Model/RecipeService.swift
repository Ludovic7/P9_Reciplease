//
//  SearchService.swift
//  Reciplease
//
//  Created by Ludovic DANGLOT on 22/09/2021.
//

import Foundation

struct RecipeReciplease: Decodable {
    let results: [RecipeResult]
}

struct RecipeResult: Decodable {
    let artistName: String
}

enum RecipeError: Error {
    case noData, invalidResponse, undecodableData
}

final class RecipeService {

    // MARK: - Properties
    
    private let session: AlamofireSession
    private var task: URLSessionTask?
    static let shared = RecipeService()
    

    // MARK: - Initializer

    init(session: AlamofireSession = RecipeSession()) {
        self.session = session
    }

    // MARK: - Management

    func getData(textToSearch : String, callback: @escaping (Result<RecipeList, RecipeError>) -> Void) {
        let scheme = "https"
        let host = "api.edamam.com"
        let path = "/api/recipes/v2"
        let queryItemQ = URLQueryItem(name: "q", value: "\(textToSearch)")
        let queryItemId = URLQueryItem(name: "app_id", value: "\(APIKeys.recipeSearchId)")
        let queryItemKey = URLQueryItem(name: "app_key", value: "\(APIKeys.recipeSearchKey)")
        let queryItemType = URLQueryItem(name: "type", value: "public")
        
        let urlComponents = URLComponents(scheme: scheme , host: host, path: path, queryItems: [queryItemType, queryItemQ, queryItemKey, queryItemId ])
        guard let url = urlComponents.url else {return}
        session.request(url: url) { dataResponse in
            guard let data = dataResponse.data else {
                callback(.failure(.noData))
                return
            }
            guard dataResponse.response?.statusCode == 200 else {
                callback(.failure(.invalidResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(RecipeList.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(dataDecoded))
        }
    }
    
    func getMoreData(urlToSearch : String, callback: @escaping (Result<RecipeList, RecipeError>) -> Void) {
        guard let url = URL(string:urlToSearch) else{return}

        session.request(url: url) { dataResponse in
            guard let data = dataResponse.data else {
                callback(.failure(.noData))
                return
            }
            guard dataResponse.response?.statusCode == 200 else {
                callback(.failure(.invalidResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(RecipeList.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(dataDecoded))
        }
    }
    


}

// MARK: - Extension

extension URLComponents {
    init(scheme: String ,
         host: String ,
         path: String ,
         queryItems: [URLQueryItem]) {
        self.init()
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
}


//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by Ludovic DANGLOT on 12/10/2021.
//

import Foundation
import Alamofire
@testable import Reciplease

    struct FakeResponse {
        var response: HTTPURLResponse?
        var data: Data?
    }

class FakeRecipleaseSession: AlamofireSession {

        // MARK: - Properties

        private let fakeResponse: FakeResponse

        // MARK: - Initializer

        init(fakeResponse: FakeResponse) {
            self.fakeResponse = fakeResponse
        }

        // MARK: - Methods

        func request(url: URL, callback: @escaping (AFDataResponse<Any>) -> Void) {
            let dataResponse = AFDataResponse<Any>(request: nil, response: fakeResponse.response, data: fakeResponse.data, metrics: nil, serializationDuration: 0, result: .success("OK"))
            callback(dataResponse)
        }
    }

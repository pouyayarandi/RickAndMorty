//
//  NetworkLayerTests.swift
//  RickAndMortyTests
//
//  Created by Pouya on 11/12/1400 AP.
//

import XCTest
@testable import RickAndMorty

struct SuccessfulResponse: Response {
    static var statusCode: Int { 200 }
    static var responseData: Data { #"{"message": "ok"}"#.data(using: .utf8)! }
}

class NetworkLayerTests: XCTestCase {
    var sut: NetworkProtocol!
    var expectation = XCTestExpectation()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockProtocol<SuccessfulResponse>.self]
        let session = URLSession(configuration: config)
        sut = NetworkLayer(session: session)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    struct Response: Codable {
        var message: String
    }
    
    func testNetworkRequest() throws {
        sut.request(.init(url: "https://example.com")) { (result: Result<Response, NetworkError>) in
            switch result {
            case .success(let value):
                XCTAssertEqual(value.message, "ok")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
}

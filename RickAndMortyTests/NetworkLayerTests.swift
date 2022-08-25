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

struct FailureResponse: Response {
    static var statusCode: Int { 404 }
    static var responseData: Data { #"{"message": "not found"}"#.data(using: .utf8)! }
}

class NetworkLayerTests: XCTestCase {
    var sut: NetworkProtocol!
    var expectation = XCTestExpectation()
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    struct Response: Codable {
        var message: String
    }
    
    func testNetworkSuccessRequest() async throws {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockProtocol<SuccessfulResponse>.self]
        let session = URLSession(configuration: config)
        sut = NetworkLayer(session: session)
        
        let response: Response = try await sut.request(.init(url: "https://example.com"))
        
        XCTAssertEqual(response.message, "ok")
    }
    
    func testNetworkFailureRequest() async throws {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockProtocol<FailureResponse>.self]
        let session = URLSession(configuration: config)
        sut = NetworkLayer(session: session)
        
        do {
            let _: Response = try await sut.request(.init(url: "https://example.com"))
        } catch let error as NetworkError {
            XCTAssertEqual(error.localizedDescription, NetworkError.httpError(404).localizedDescription)
        } catch {
            XCTFail("Error should be `NetworkError`")
        }
    }
}

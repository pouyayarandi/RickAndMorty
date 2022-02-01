//
//  NetworkLayerTests.swift
//  RickAndMortyTests
//
//  Created by Pouya on 11/12/1400 AP.
//

import XCTest
@testable import RickAndMorty

class MockProtocol: URLProtocol {
    var statusCode: Int = 200
    var response: String = #"{"message": "ok"}"#
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func stopLoading() {}
    override func startLoading() {
        client?.urlProtocol(self, didLoad: response.data(using: .utf8)!)
        client?.urlProtocol(self, didReceive: HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!, cacheStoragePolicy: .notAllowed)
        client?.urlProtocolDidFinishLoading(self)
    }
}

class NetworkLayerTests: XCTestCase {
    var sut: NetworkProtocol!
    var expectation = XCTestExpectation()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockProtocol.self]
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

//
//  NetworkLayerTests.swift
//  RickAndMortyTests
//
//  Created by Pouya on 11/12/1400 AP.
//

import XCTest
@testable import RickAndMorty

class NetworkLayerTests: XCTestCase {
    var sut: NetworkProtocol!
    var expectation = XCTestExpectation()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkLayer(session: .shared)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    struct Response: Codable {}
    
    func testNetworkRequest() throws {
        sut.request(.init(url: "https://rickandmortyapi.com/api/character")) { (result: Result<Response, NetworkError>) in
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .success:
                break
            }
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
}

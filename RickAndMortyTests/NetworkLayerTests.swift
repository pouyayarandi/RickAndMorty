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
    }
    
    func testNetworkRequest() throws {
        sut.request(.init(url: "https://rickandmortyapi.com/api/character")) { (result: Result<Data, NetworkError>) in
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

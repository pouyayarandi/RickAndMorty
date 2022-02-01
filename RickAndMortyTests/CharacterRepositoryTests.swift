//
//  CharacterRepositoryTests.swift
//  RickAndMortyTests
//
//  Created by Pouya on 11/12/1400 AP.
//

import XCTest
@testable import RickAndMorty

class CharacterRepositoryTests: XCTestCase {
    
    var sut: CharacterRepositoryProtocol!
    var networkLayer: MockNetworkLayer!
    var expectation = XCTestExpectation()

    override func setUpWithError() throws {
        try super.setUpWithError()
        networkLayer = MockNetworkLayer()
        sut = CharacterRepository(network: networkLayer)
    }

    override func tearDownWithError() throws {
        sut = nil
        networkLayer = nil
        try super.tearDownWithError()
    }

    func testGetFirstCharacterPage() throws {
        let firstPageResponse: CharacterListResponse = FileHelper.objectFromFile("Character-1")
        networkLayer.mocks[.init(url: "https://rickandmortyapi.com/api/character")] = .success(firstPageResponse)
        
        sut.getCharactersFirstPage { result in
            let response = try! result.get()
            XCTAssertEqual(response.results.first?.name, "Rick Sanchez")
            XCTAssertTrue(response.pageData.hasNextPage)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetFirstCharacterPageThenSecondPage() throws {
        let firstPageResponse: CharacterListResponse = FileHelper.objectFromFile("Character-1")
        networkLayer.mocks[.init(url: "https://rickandmortyapi.com/api/character")] = .success(firstPageResponse)
        let secondPageResponse: CharacterListResponse = FileHelper.objectFromFile("Character-2")
        networkLayer.mocks[.init(url: "https://rickandmortyapi.com/api/character?page=2")] = .success(secondPageResponse)
        
        sut.getCharactersFirstPage { result in
            let response = try! result.get()
            XCTAssertEqual(response.results.first?.name, "Rick Sanchez")
            XCTAssertTrue(response.pageData.hasNextPage)
            self.sut.getCharactersNextPage { result in
                XCTAssertEqual((try! result.get()).results.first!.name, "Aqua Morty")
                self.expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
}

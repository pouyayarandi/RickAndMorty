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

    func testGetFirstCharacterPage() async throws {
        let firstPageResponse: CharacterListResponse = FileHelper.objectFromFile("Character-1")
        networkLayer.mocks[.init(url: "https://rickandmortyapi.com/api/character")] = .success(firstPageResponse)
        
        let response = try await sut.getCharactersFirstPage()
        
        XCTAssertEqual(response.results.first?.name, "Rick Sanchez")
        XCTAssertTrue(response.pageData.hasNextPage)
    }
    
    func testGetFirstCharacterPageThenSecondPage() async throws {
        let firstPageMockResponse: CharacterListResponse = FileHelper.objectFromFile("Character-1")
        networkLayer.mocks[.init(url: "https://rickandmortyapi.com/api/character")] = .success(firstPageMockResponse)
        let secondPageMockResponse: CharacterListResponse = FileHelper.objectFromFile("Character-2")
        networkLayer.mocks[.init(url: "https://rickandmortyapi.com/api/character?page=2")] = .success(secondPageMockResponse)
        
        let firstPageResponse = try await sut.getCharactersFirstPage()
        XCTAssertEqual(firstPageResponse.results.first?.name, "Rick Sanchez")
        XCTAssertTrue(firstPageResponse.pageData.hasNextPage)
        
        let nextPageResponse = try await sut.getCharactersNextPage()
        XCTAssertEqual(nextPageResponse?.results.first?.name, "Aqua Morty")
    }
}

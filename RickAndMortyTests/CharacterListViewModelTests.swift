//
//  CharacterListViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Pouya on 11/14/1400 AP.
//

import Foundation
@testable import RickAndMorty
import XCTest

class CharacterListViewModelTests: XCTestCase {
    var sut: CharacterListViewModelProtocol!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let container = MockContainer()
        sut = CharacterListViewModel(container: container)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testViewDidLoad() async throws {
        await sut.viewDidLoad()
        XCTAssertEqual(sut.output.items.last?.name, "Ants in my Eyes Johnson")
        XCTAssertEqual(sut.output.items.count, 20)
    }
    
    func testViewDidRequestForNextPage() async {
        await sut.viewDidLoad()
        await sut.viewDidRequestForNextPage()
        XCTAssertEqual(sut.output.items.last?.name, "Beth's Mytholog")
        XCTAssertEqual(sut.output.items.count, 40)
    }
}

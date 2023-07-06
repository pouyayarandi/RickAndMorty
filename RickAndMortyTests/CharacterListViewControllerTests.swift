//
//  CharacterListViewControllerTests.swift
//  RickAndMortyTests
//
//  Created by Pouya on 11/14/1400 AP.
//

import Foundation
import XCTest
import Combine
import SnapshotTesting
@testable import RickAndMorty

class MockImageCache: ImageCacheProtocol {
    func getImage(for url: URL) -> UIImage? {
        UIImage(named: "TestImage", in: .test, compatibleWith: nil)
    }
    
    func storeImage(_ image: UIImage, for url: URL) {}
    func reset() {}
}

class MockCharacterListViewModel: CharacterListViewModelProtocol {
    @Published var _items: [CharacterResponse] = []
    var items: Output<[CharacterResponse]> {
        (_items, $_items.eraseToAnyPublisher())
    }
    
    var error: AnyPublisher<String, Never> {
        Empty().eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        let data: CharacterListResponse = FileHelper.objectFromFile("Character-1")
        _items = data.results
    }
    
    func viewDidRequestForNextPage() {}
}

class CharacterListViewControllerTests: XCTestCase {
    var sut: CharacterListViewController!

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    @MainActor
    func testLoadCharacterListView() async {
        let viewModel = MockCharacterListViewModel()
        sut = CharacterListViewController(viewModel: viewModel)
        sut.imageCache = MockImageCache()
        sut.loadViewIfNeeded()
        
        viewModel.viewDidLoad()
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 20)
    }
}

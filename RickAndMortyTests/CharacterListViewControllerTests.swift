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
    var items: CurrentValueSubject<[CharacterResponse], Never> = .init([])
    
    func viewDidLoad() {
        let data: CharacterListResponse = FileHelper.objectFromFile("Character-1")
        items.send(data.results)
    }
    
    func viewDidRequestForNextPage() {}
}

class CharacterListViewControllerTests: XCTestCase {
    var sut: CharacterListViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = CharacterListViewController()
        sut.viewModel = MockCharacterListViewModel()
        sut.imageCache = MockImageCache()
    }
    
    func testLoadCharacterListView() {
        sut.loadViewIfNeeded()
        assertSnapshot(matching: sut, as: .image(on: .iPhone8))
        assertSnapshot(matching: sut, as: .image(on: .iPhone8, traits: .init(userInterfaceStyle: .dark)))
    }
}

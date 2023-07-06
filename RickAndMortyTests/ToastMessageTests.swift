//
//  ToastMessageTests.swift
//  RickAndMortyTests
//
//  Created by Pouya on 6/4/1401 AP.
//

import XCTest
@testable import RickAndMorty

class ToastMessageTests: XCTestCase {
    override func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }
    
    @MainActor
    func testShowToastMessage() async throws {
        ToastMessage.dismissAutomatically = false
        let view = UIView()
        
        await ToastMessage.showError(message: "Some message", on: view)
        
        XCTAssertEqual(view.subviews.count, 1)
    }
    
    @MainActor
    func testToastMessageIsBeingRemovedAfter() async throws {
        ToastMessage.dismissAutomatically = true
        let view = UIView()
        
        await ToastMessage.showError(message: "Some message", on: view, duration: 0)
        
        XCTAssertTrue(view.subviews.isEmpty)
    }
}

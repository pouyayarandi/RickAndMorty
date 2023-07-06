//
//  RickAndMortyUITests.swift
//  RickAndMortyUITests
//
//  Created by Pouya on 11/12/1400 AP.
//

import XCTest

class RickAndMortyUITests: XCTestCase {
    var app: XCUIApplication!
    var page: BasePage!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = .init()
        page = .init(app: app)
        page.launchApp()
    }

    override func tearDownWithError() throws {
        page.terminateApp()
        page = nil
        app = nil
        try super.tearDownWithError()
    }

    func testCharacterListPagination() {
        page
            .selectCharactersTab()
            .assertInitialCharactersToBeMoreThanZero()
            .scrollToLastCharcter()
            .assertCurrentCharactersToBeMoreThanInitialOnes()
    }
    
    func testChangeTabToLocation() {
        page
            .selectLocationsTab()
            .assertInitialLocationsToBeMoreThanZero()
            .scrollToLastLocation()
            .assertCurrentLocationsToBeMoreThanInitialOnes()
    }
}

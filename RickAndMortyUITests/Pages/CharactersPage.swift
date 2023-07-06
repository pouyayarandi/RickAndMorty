//
//  CharactersPage.swift
//  RickAndMortyUITests
//
//  Created by Pouya on 4/15/1402 AP.
//

import XCTest

import XCTest

class CharactersPage: Page {
    var app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    private var cells: XCUIElementQuery {
        app.tables.firstMatch.cells
    }
    
    private var lastCell: XCUIElement {
        _ = cells.firstMatch.waitForExistence(timeout: 0.5)
        return cells.allElementsBoundByIndex.last!
    }
    
    private lazy var initialCellCount: Int = {
        cells.count
    }()
    
    private var table: XCUIElement {
        app.tables.firstMatch
    }
    
    @discardableResult
    func assertInitialCharactersToBeMoreThanZero() -> Self {
        XCTAssertGreaterThan(initialCellCount, 0)
        return self
    }
    
    func scrollToLastCharcter() -> Self {
        let lastCell = self.lastCell
        while lastCell.isHittable == false {
            table.swipeUp()
        }
        return self
    }
    
    @discardableResult
    func assertCurrentCharactersToBeMoreThanInitialOnes() -> Self {
        XCTAssertGreaterThan(cells.count, initialCellCount)
        return self
    }
}


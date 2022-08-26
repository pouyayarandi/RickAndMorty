//
//  RickAndMortyUITests.swift
//  RickAndMortyUITests
//
//  Created by Pouya on 11/12/1400 AP.
//

import XCTest

class RickAndMortyUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCharacterListPagination() {
        let app = XCUIApplication()
        app.launch()

        let table = app.tables.firstMatch
        _ = table.cells.firstMatch.waitForExistence(timeout: 0.5)
        let cellCountBeforePagination = app.cells.count
        let lastCell = app.cells.allElementsBoundByIndex.last!
        
        XCTAssertGreaterThan(cellCountBeforePagination, 0)
        
        while !lastCell.isHittable {
            table.swipeUp()
        }
        _ = table.cells.firstMatch.waitForExistence(timeout: 0.5)
        
        XCTAssertEqual(table.cells.count, cellCountBeforePagination * 2)
    }
    
    func testChangeTabToLocation() {
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars.firstMatch.buttons["Locations"].tap()
        let cells = app.tables.firstMatch.cells
        _ = cells.firstMatch.waitForExistence(timeout: 0.5)
        let lastCell = cells.allElementsBoundByIndex.last!
        let initialCellCount = cells.count
        
        XCTAssertGreaterThan(initialCellCount, 0)
        
        while !lastCell.isHittable {
            app.tables.firstMatch.swipeUp()
        }
        
        XCTAssertGreaterThan(app.tables.firstMatch.cells.count, initialCellCount)
    }
}

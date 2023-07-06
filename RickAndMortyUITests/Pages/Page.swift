//
//  Page.swift
//  RickAndMortyUITests
//
//  Created by Pouya on 4/15/1402 AP.
//

import XCTest

protocol Page {
    var app: XCUIApplication { get }
}

extension Page {
    @discardableResult
    func launchApp() -> Self {
        app.launch()
        return self
    }

    @discardableResult
    func terminateApp() -> Self {
        app.terminate()
        return self
    }
}

struct BasePage: Page {
    var app: XCUIApplication
    
    private var tabBars: XCUIElementQuery {
        app.tabBars.firstMatch.buttons
    }
    
    private var locationTab: XCUIElement {
        tabBars["Locations"]
    }

    private var charactersTab: XCUIElement {
        tabBars["Characters"]
    }
    
    func selectCharactersTab() -> CharactersPage {
        charactersTab.tap()
        return CharactersPage(app: app)
    }
    
    func selectLocationsTab() -> LocationsPage {
        locationTab.tap()
        return LocationsPage(app: app)
    }
}

//
//  StrideSyncUITests.swift
//  StrideSyncUITests
//
//  Created by Stef Castillo on 1/22/24.
//

import XCTest

final class StrideSyncUITests: XCTestCase {

        func testNavigationToDayDetailsView() {
            let app = XCUIApplication()
            app.launch()
            
            let firstCell = app.firstMatch.otherElements.cells.firstMatch
            firstCell.tap()
            
        }
}

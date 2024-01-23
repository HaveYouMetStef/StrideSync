//
//  FormattedDateTest.swift
//  StrideSyncTests
//
//  Created by Stef Castillo on 1/22/24.
//

import XCTest
@testable import StrideSync

final class FormattedDateTest: XCTestCase {

    func testFormattedDate() {
        let viewModel = StepTrackerViewModel()
        let dayDetailsView = DayDetailsView(stepData: StepData(date: Date(), steps: 0, distance: 0.0), viewModel: viewModel)

            // Choose a specific date for testing
            let testDate = Date(timeIntervalSince1970: 1697788800)

            // Expected formatted date for the chosen date
            let expectedFormattedDate = "Friday - 10/20/23"

            // Call the formattedDate function
            let formattedDate = dayDetailsView.formattedDate(from: testDate)

            // Assert that the formatted date matches the expected result
            XCTAssertEqual(formattedDate, expectedFormattedDate)
        }

}

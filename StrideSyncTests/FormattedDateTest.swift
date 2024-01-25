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
        //MARK: Arrange
        let viewModel = StepTrackerViewModel()
        let dayDetailsView = DayDetailsView(stepData: StepData(date: Date(), steps: 0, distance: 0.0), viewModel: viewModel)
            
            //MARK: Act
            // Wedding day
            let testDate = Date(timeIntervalSince1970: 1697788800)

            //formatted date
            let expectedFormattedDate = "Friday - 10/20/23"

            // Call the function
            let formattedDate = dayDetailsView.formattedDate(from: testDate)

            // MARK: Assert 
            XCTAssertEqual(formattedDate, expectedFormattedDate)
        }

}

//
//  DayDetailsViewTest.swift
//  StrideSyncTests
//
//  Created by Stef Castillo on 1/22/24.
//

import XCTest
@testable import StrideSync



final class DayDetailsViewTest: XCTestCase {

    func testDayDetailsViewContent() {
        //MARK: Arrange & Act
        let stepData = StepData(date: Date(), steps: 2000, distance: 1.0)
        let viewModel = StepTrackerViewModel()
        let dayDetailsView = DayDetailsView(stepData: stepData, viewModel: viewModel)
        
        let stepsText = dayDetailsView.stepData.steps
        
        let distanceText = dayDetailsView.stepData.distance

        //MARK: Assert
        XCTAssertNotNil(stepsText)
        XCTAssertEqual(stepsText, 2000)
        XCTAssertEqual(distanceText, 1.0)
    }

}

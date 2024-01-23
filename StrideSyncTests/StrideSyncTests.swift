//
//  StrideSyncTests.swift
//  StrideSyncTests
//
//  Created by Stef Castillo on 1/22/24.
//

import XCTest
@testable import StrideSync
import CoreMotion

final class StrideSyncTests: XCTestCase {
    
    // CMPedometer test
        class MockPedometer: CMPedometer {
            
            static var isPedometerAvailable = true
            static var queryHandler: ((Date, Date, @escaping CMPedometerHandler) -> Void)?
            
            override class func isPedometerEventTrackingAvailable() -> Bool {
                return isPedometerAvailable
            }
            
            override func queryPedometerData(from start: Date, to end: Date, withHandler handler: @escaping CMPedometerHandler) {
                MockPedometer.queryHandler?(start, end, handler)
            }
        }
    
    func testStepTrackerViewModel() {
            // Arrange
            let viewModel = StepTrackerViewModel()
            MockPedometer.isPedometerAvailable = true
            
            // Set up the query handler for the pedometer
            MockPedometer.queryHandler = { start, end, handler in
                // Simulate pedometer data
                let simulatedData = CMPedometerData()
                handler(simulatedData, nil)
            }
            
            // Act
            viewModel.initializePedometer()
            
            // Assert
        XCTAssertEqual(viewModel.stepDataList.isEmpty, true) // Adjust based on your expected behavior
        }
    
}


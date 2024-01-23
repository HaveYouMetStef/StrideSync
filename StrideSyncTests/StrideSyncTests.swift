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
    
    //CMPedometer test
    class MockPedemeter: CMPedometer {
        
        static var isPedometerAvailable = true
        override class func isPedometerEventTrackingAvailable() -> Bool {
            
            return isPedometerAvailable
        }
        
        override func queryPedometerData(from start: Date, to end: Date, withHandler handler: @escaping CMPedometerHandler) {
            if MockPedemeter.isPedometerAvailable{
                let simulatedData = CMPedometerData()
                
                handler(simulatedData, nil)
            } else {
                
                let error = NSError(domain: CMErrorDomain, code: 0, userInfo: nil)
                handler(nil, error)
            }
        }
        
    }
}


//
//  StepTrackerViewModel.swift
//  StrideSync
//
//  Created by Stef Castillo on 1/23/24.
//

import Foundation
import CoreMotion //will give you access to CMPedometer
import SwiftUI


class StepTrackerViewModel: ObservableObject {
    
    private let stepTracker: CMPedometer = CMPedometer()
    
    @Published var stepDataList: [StepData] = []
    
    init() {
        initializePedometer()
    }
    
     func initializePedometer() {
        if CMPedometer.isPedometerEventTrackingAvailable() {
            let calendar = Calendar.current
            let endDate = Date()
            let totalDistance = Double()
            
            // Include today's step data
            if let startOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: endDate),
               let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) {
                stepTracker.queryPedometerData(from: startOfDay, to: endOfDay) { (data, error) in
                    guard let data = data, error == nil else { return }
                    let totalSteps = data.numberOfSteps.intValue
                    let totalDistance = data.distance?.doubleValue ?? 0.0
                    let distanceInMiles = Measurement(value: totalDistance, unit: UnitLength.meters).converted(to: .miles).value
                    let stepData = StepData(date: endDate, steps: totalSteps, distance: distanceInMiles)
                    self.stepDataList.append(stepData)
                }
            }
            
            
            // Retrieve step data for the past 6 days
            //YES!!! - adjusted the for loop to loop over the startDate rather than end date.
            for i in 1..<7 {
                guard let startDate = calendar.date(byAdding: .day, value: -i, to: endDate),
                      let startOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: startDate),
                      let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)
                else {
                    continue
                }
                
                stepTracker.queryPedometerData(from: startOfDay, to: endOfDay) { (data, error) in
                    guard let data = data, error == nil else { return }
                    let totalSteps = data.numberOfSteps.intValue
                    let totalDistance = data.distance?.doubleValue ?? 0.0
                    let distanceInMiles = Measurement(value: totalDistance, unit: UnitLength.meters).converted(to: .miles).value
                    let stepData = StepData(date: startDate, steps: totalSteps, distance: distanceInMiles)
                    self.stepDataList.append(stepData)
                }
            }
        }
        //MARK: Fake data if there is no physical device
        else {
            let endDate = Date()
            
            for i in 0..<7 {
                let startdate = Calendar.current.date(byAdding: .day, value: -i, to: endDate)!
                let fakeSteps = Int.random(in: 0...10_000) //Random steps
                let fakeDistanceWalked = Double.random(in: 1...100)
                let stepData = StepData(date: startdate, steps: fakeSteps, distance: Double(fakeDistanceWalked))
                self.stepDataList.append(stepData)
            }
        }
    }
}

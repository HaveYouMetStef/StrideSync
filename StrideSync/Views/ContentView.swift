//
//  ContentView.swift
//  StrideSync
//
//  Created by Stef Castillo on 1/18/24.
//

import SwiftUI
//Must use the CoreMotion framework to get access to CMPedometer
import CoreMotion

//Data Model - for tracking the steps for each day
struct StepData {
    var date: Date
    var steps: Int
}



struct ContentView: View {
    
    private let stepTracker: CMPedometer = CMPedometer()
    
    
    @State private var steps: Int?
    @State private var distance: Double?
    @State private var stepDataList: [StepData] = []
    
    private var isPedometerAvailable: Bool {
        
        return CMPedometer.isPedometerEventTrackingAvailable() && CMPedometer.isDistanceAvailable() && CMPedometer.isStepCountingAvailable() && CMPedometer.isFloorCountingAvailable()
    }
    
    //MARK: Functions
    //measurement api - converting meters to miles
    private func updateUI(data: CMPedometerData) {
        
        steps = data.numberOfSteps.intValue
        
        guard let pedometerDistance = data.distance else { return }
        
        let distanceInMeters = Measurement(value: Double(truncating: pedometerDistance), unit: UnitLength.meters)
        
        distance = distanceInMeters.converted(to: .miles).value
        
        //add step data to the list
        let stepData = StepData(date: data.endDate, steps: steps ?? 0)
        stepDataList.append(stepData)
        
    }
    
    
    
    //needs to be able to split into 7 seperate days
    private func initializePedometer() {
        
        if isPedometerAvailable {
            
            let calendar = Calendar.current
            let endDate = Date()
            
            //Daily Step data
            var dailyStepData: [StepData] = []
            
            for i in 0..<7 {
                guard let startDate = calendar.date(byAdding: .day, value: -i, to: endDate) else {
                    continue
                }
                
                stepTracker.queryPedometerData(from: startDate, to: endDate) { (data, error) in
                    guard let data = data, error == nil else { return }
                    
                    
                    //Update UI with the current day's data
                    updateUI(data: data)
                    
                    //existing data
                    var existingData = dailyStepData.first(where: {$0.date == startDate}) ?? StepData(date: startDate, steps: 0)
                    
                    //update steps with existingData
                    existingData.steps += data.numberOfSteps.intValue
                    
                    if let index = dailyStepData.firstIndex(where: { $0.date == startDate }) {
                        dailyStepData[index] = existingData
                    } else {
                        dailyStepData.append(existingData)
                    }
                    
                    
                    // If it's the last iteration, update the main list with all the daily data
                    if i == 6 {
                        stepDataList = dailyStepData.sorted(by: { $0.date > $1.date })
                    }
                }
            }
        }
    }
    
    //MARK: UI of Main Screen
    var body: some View {
        VStack {
            NavigationView {
                List(stepDataList, id: \.date) { stepData in
                    VStack(alignment: .leading) {
                        Text("\(stepData.date, formatter: dateFormatter)")
                        Text("\(stepData.steps) Steps")
                    }
                }
                //title
                .navigationTitle("StrideSync")
                
//                Text(distance != nil ? String(format: "%.2f  Miles", distance!) : "0")
                
                    .onAppear {
                        initializePedometer()
                    }
            }
            
        }
        .padding()
    }
    
    
    //Date Formatter
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

#Preview {
    ContentView()
}

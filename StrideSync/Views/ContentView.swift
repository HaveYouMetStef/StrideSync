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
    @State private var stepDataList: [StepData] = []
    @State private var selectedStepData: StepData?

    
    
    private func initializePedometer() {
        if CMPedometer.isPedometerEventTrackingAvailable() {
            let calendar = Calendar.current
            let endDate = Date()

            // Include today's step data
            if let startOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: endDate),
               let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) {
                stepTracker.queryPedometerData(from: startOfDay, to: endOfDay) { (data, error) in
                    guard let data = data, error == nil else { return }
                    let totalSteps = data.numberOfSteps.intValue
                    let stepData = StepData(date: endDate, steps: totalSteps)
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
                    let stepData = StepData(date: startDate, steps: totalSteps)
                    self.stepDataList.append(stepData)
                }
            }
        } 
        //MARK: Fake data if there is no physical device
        else {
            let endDate = Date()
            
            for i in 0..<7 {
                let startdate = Calendar.current.date(byAdding: .day, value: -i, to: endDate)!
                let fakeSteps = Int.random(in: 1000...10_000) //Random steps
                let stepData = StepData(date: startdate, steps: fakeSteps)
                self.stepDataList.append(stepData)
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
                .navigationBarTitle("StrideSync")
            }

        }
        .onAppear {
            initializePedometer()
        
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

//
//  ContentView.swift
//  StrideSync
//
//  Created by Stef Castillo on 1/18/24.
//

import SwiftUI
//Must use the CoreMotion framework to get access to CMPedometer
import CoreMotion



//MARK: Data Model - for tracking the steps for each day
struct StepData:Identifiable, Hashable {
    var id = UUID()
    var date: Date
    var steps: Int
    var distance: Double
}

struct ContentView: View {
    private let stepTracker: CMPedometer = CMPedometer()
    @State private var stepDataList: [StepData] = []
    @State private var selectedStepData: StepData?

    
    
    private func initializePedometer() {
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
                let fakeSteps = Int.random(in: 1000...10_000) //Random steps
                let fakeDistanceWalked = Double.random(in: 1...100)
                let stepData = StepData(date: startdate, steps: fakeSteps, distance: Double(fakeDistanceWalked))
                self.stepDataList.append(stepData)
            }
        }
    }
    
    //MARK: UI of Main Screen
    var body: some View {
        VStack {
            NavigationView {
                List(stepDataList, id: \.date) { stepData in
                    NavigationLink(destination: DayDetailsView(stepData: stepData), label: {
                        VStack(alignment: .leading) {
                            Text("\(stepData.date, formatter: dateFormatter)")
                            Text("\(stepData.steps) Steps")
                        }
                    }
                    )
                }
                //MARK: Must be on the NavigationView
                .navigationBarTitle("StrideSync")
                
            }
            .onAppear {
                initializePedometer()
                
            }
        }
        .padding()
}
    
    //MARK: Day Details View (2nd screen)
    
    struct DayDetailsView: View {
        var stepData: StepData
        
        var body: some View {
            VStack {
                Text("Date: \(stepData.date, formatter: dateFormatter)")
                Text("\(stepData.steps) Steps")
                Text("\(stepData.distance, specifier: "%.2f") Miles Walked")
            }
            .padding()
            .navigationTitle("Details")
        }
    }
}

//Date Formatter
private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}

#Preview {
    ContentView()
}

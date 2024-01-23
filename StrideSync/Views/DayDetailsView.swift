//
//  DayDetailsView.swift
//  StrideSync
//
//  Created by Stef Castillo on 1/23/24.
//

import SwiftUI


struct DayDetailsView: View {
    var stepData: StepData
    @ObservedObject var viewModel: StepTrackerViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("\(stepData.steps) Steps")
                    .font(.title)
                Text("\(stepData.distance, specifier: "%.2f") Miles Walked")
                    .font(.headline)
                Spacer()
            }
            .navigationTitle("\(formattedDate(from: stepData.date))")
        }
        .padding()
        .accessibility(identifier: "DayDetailsView")
    }
    
     func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - M/d/yy"
        return formatter.string(from: date)
    }
}

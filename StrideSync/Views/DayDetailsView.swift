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
                //Card
                RoundedRectangle(cornerRadius: 40)
                    .opacity(0.2)
                        .overlay(
                VStack {
                    
                    Image(systemName: "flame.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                        .padding(.top, 20)
                    
                    //MARK: Steps
                    Text("\(stepData.steps) Steps")
                        .font(.title)
                        .padding(.top, 20)
                    
                    
                    //MARK: Distance
                    Text("\(stepData.distance, specifier: "%.2f") Miles Walked")
                        .font(.headline)
                }
                    .padding()
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .navigationTitle("\(formattedDate(from: stepData.date))")
            
            //Check if the view will show
            .onAppear {
                print("View Appeared")
            }
            .onDisappear {
                print("View Disappeared")
            }
        }
        .accessibility(identifier: "DayDetailsView")
    }
    
     func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - M/d/yy"
        return formatter.string(from: date)
    }
}

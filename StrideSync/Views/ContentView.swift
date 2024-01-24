//
//  ContentView.swift
//  StrideSync
//
//  Created by Stef Castillo on 1/18/24.
//

import SwiftUI




struct ContentView: View {
    
    @StateObject private var viewModel = StepTrackerViewModel()
    
    @Environment (\.dismiss) var dismiss
    
    
    //MARK: UI of Main Screen
    var body: some View {
        VStack {
            NavigationView {
                List(viewModel.stepDataList, id: \.id) { stepData in
                    NavigationLink(destination: DayDetailsView(stepData: stepData, viewModel: viewModel)) {
                        HStack {
                            VStack(alignment:.leading) {
                                Text("\(stepData.date, formatter: dateFormatter)")
                                Text("\(stepData.steps) Steps")
                            }
                            Spacer()
                            Spacer()
                            Text(stepEmoji(for:stepData.steps))
                        }
                    }
                    .highPriorityGesture(DragGesture(minimumDistance: 10, coordinateSpace: .local) //Back geture - allows you to swipe back to the previous screen
                        .onChanged{value in
                            guard value.startLocation.x <= 40 else {
                                return
                            }
                            dismiss()
                        }
                    )
                    
                }

                //MARK: Must be on the NavigationView
                .navigationBarTitle("StrideSync")
            }
            .padding()
        }
    }
    
    //MARK: Emoji function
    func stepEmoji(for steps: Int) -> String {
        switch steps {
        case 0..<1000:
            return "🛑"
        case 1000..<3999:
            return "🟡"
        default:
            return "🟢"
            
        }
    }
}

//MARK: Date Formatter
private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}


#Preview {
    ContentView()
}

//
//  ContentView.swift
//  StrideSync
//
//  Created by Stef Castillo on 1/18/24.
//

import SwiftUI




struct ContentView: View {
    
    @StateObject private var viewModel = StepTrackerViewModel()

    
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

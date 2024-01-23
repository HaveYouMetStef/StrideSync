//
//  StepData.swift
//  StrideSync
//
//  Created by Stef Castillo on 1/23/24.
//

import Foundation


struct StepData:Identifiable, Hashable {
    var id = UUID()
    var date: Date
    var steps: Int
    var distance: Double
}

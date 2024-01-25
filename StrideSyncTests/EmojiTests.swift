//
//  EmojiTests.swift
//  StrideSyncTests
//
//  Created by Stef Castillo on 1/22/24.
//

import XCTest
@testable import StrideSync
import SwiftUI


final class EmojiTests: XCTestCase {

    //MARK: Arange
    func testStepEmoji() {
        let contentView = ContentView()
        
        func testStepEmoji() {
                let contentView = ContentView()
                
            //MARK: Act
                // Test for steps less than 1000
                let emoji1 = contentView.stepEmoji(for: 500)

                // Test for steps between 1000 and 3999
                let emoji2 = contentView.stepEmoji(for: 3000)

                // Test for steps 4000 and above
                let emoji3 = contentView.stepEmoji(for: 5000)
            
            //MARK: Assert
            XCTAssertEqual(emoji1 as! Text , Text("🛑"))
            XCTAssertEqual(emoji2 as! Text, Text("🟡"))
            XCTAssertEqual(emoji3 as! Text,Text("🟢"))
            }
    }

}

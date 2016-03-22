//
//  PopTipTransitionAnimationTests.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/30/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import XCTest
@testable import TransitionTreasury

class PopTipTransitionAnimationTests: XCTestCase {
    
    var visibleHeight: CGFloat?
    
    var transition: PopTipTransitionAnimation?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        visibleHeight = 500
        transition = PopTipTransitionAnimation(visibleHeight: visibleHeight ?? 0)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        visibleHeight = nil
        transition = nil
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(transition, "Transition should be load.")
    }
    
    func testVisibleHeight() {
        XCTAssertEqual(visibleHeight, transition?.visibleHeight, "VisibleHeight should be equal.")
    }
    
    func testTransitionDuration() {
        XCTAssertEqual(0.3, transition?.transitionDuration(nil), "Transition Duration should be 0.3s.")
    }
    

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}

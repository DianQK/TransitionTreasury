//
//  FadeTransitionAnimationTests.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/30/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import XCTest
@testable import TransitionTreasury
@testable import TransitionAnimation

class FadeTransitionAnimationTests: XCTestCase {
    
    var transition: FadeTransitionAnimation?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        transition = FadeTransitionAnimation()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        transition = nil
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(transition, "Transition should be load.")
    }
    
    func testTransitionDuration() {
        XCTAssertEqual(0.3, transition?.transitionDuration(nil), "Transition Duration should be 0.3s.")
    }
    
}

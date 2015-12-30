//
//  TwitterTransitionAnimationTests.swift
//  TransitionTreasury
//
//  Created by 宋宋 on 12/30/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import XCTest
@testable import TransitionTreasury

class TwitterTransitionAnimationTests: XCTestCase {
    
    var transition: TwitterTransitionAnimation?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        transition = TwitterTransitionAnimation()
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
        XCTAssertEqual(0.6, transition?.transitionDuration(nil), "Transition Duration should be 0.6s.")
    }
    
}

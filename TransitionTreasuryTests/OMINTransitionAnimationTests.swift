//
//  OMINTransitionAnimationTests.swift
//  TransitionTreasury
//
//  Created by 宋宋 on 12/30/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import XCTest
@testable import TransitionTreasury

class OMINTransitionAnimationTests: XCTestCase {
    
    var keyView: UIView?
    
    var transition: OMINTransitionAnimation?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        keyView = UIView()
        transition = OMINTransitionAnimation(key: keyView)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        keyView = nil
        transition = nil
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(transition, "Transition should be load.")
    }
    
    func testTransitionDuration() {
        XCTAssertEqual(0.3, transition?.transitionDuration(nil), "Transition Duration should be 0.3s.")
    }
    
    func testKeyView() {
        XCTAssertNotNil(transition?.keyView, "KeyView should not be nil.")
    }
    
    func testAnimateTransition() {
        transition?.animateTransition(UIViewControllerContextTransitioning)
    }
    
    func testTransitionPerformance() {
        let mainVC = MainViewController()
        let secondVC = SecondViewController()
        _ = UINavigationController(rootViewController: mainVC)
        
        self.measureBlock({
            mainVC.navigationController?.tr_pushViewController(secondVC, method: .Custom(self.transition!), completion: {
                debugPrint("Push finished.")
            })
        })
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

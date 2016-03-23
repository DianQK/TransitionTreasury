//
//  TRNavgationTransitionDelegateTests.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/30/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import XCTest
@testable import TransitionTreasury
@testable import TransitionAnimation

class TRNavgationTransitionDelegateTests: XCTestCase {
    
    var transitionDelegate: TRNavgationTransitionDelegate?
    
    var mainVC: MainViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mainVC = MainViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mainVC = nil
        super.tearDown()
    }
    
    func testTransitioning() {
        XCTAssertNotNil(mainVC, "MainVC should be load.")
        
        weak var weakSecondVC : SecondViewController?
        let transitioning : () -> Void = {
            let secondVC = SecondViewController()
            XCTAssertNotNil(secondVC, "SecondVC should be load.")
            weakSecondVC = secondVC
            XCTAssertNotNil(weakSecondVC, "WeakSecondVC should be load.")
            let nav = UINavigationController(rootViewController: self.mainVC!)
            XCTAssertEqual(nav, self.mainVC?.navigationController, "NavgationController should be equal.")
//            self.mainVC!.navigationController?.tr_pushViewController(secondVC, method: TRPushTransitionMethod.Fade)
            
            
            self.mainVC?.navigationController?.tr_pushViewController(secondVC, method: TRPushTransitionMethod.Fade)
            XCTAssertNotNil(secondVC.tr_pushTransition, "TRTransitionDelegate should be load.")
            XCTAssertNotNil(self.mainVC?.navigationController?.delegate, "Delegate should be set.")
            XCTAssertNotNil(secondVC.tr_pushTransition?.previousStatusBarStyle, "Transition should support update status bar style.")
            XCTAssertEqual(secondVC.tr_pushTransition, self.mainVC?.navigationController?.delegate as? TRNavgationTransitionDelegate, "Transition delegate should be equal delegate.")
            secondVC.navigationController?.tr_popViewController()
        }
        transitioning()
        
        XCTAssertNil(weakSecondVC, "SecondVC should be nil after pop.")
        XCTAssertNil(mainVC?.navigationController?.delegate, "Delegate should be nil after pop.")
        
    }
    
}

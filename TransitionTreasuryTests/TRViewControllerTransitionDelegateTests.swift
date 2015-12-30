//
//  TRViewControllerTransitionDelegateTests.swift
//  TransitionTreasury
//
//  Created by 宋宋 on 12/30/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import XCTest
@testable import TransitionTreasury

class TRViewControllerTransitionDelegateTests: XCTestCase {
    
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
        weak var weakModalVC: ModalViewController?
        let transitioning: () -> Void = {
            let  modalVC = ModalViewController()
            modalVC.modalDelegate = self.mainVC
            weakModalVC = modalVC
            XCTAssertNotNil(weakModalVC, "WeakModalVC should not be nil.")
            self.mainVC?.tr_presentViewController(modalVC, method: .Fade)
            XCTAssertNotNil(self.mainVC?.tr_transition, "TRTransition should not be nil.")
            XCTAssertNotNil(modalVC.transitioningDelegate, "TransitionDelegate should not be nil.")
            modalVC.modalDelegate!.modalViewControllerDismiss(callbackData: nil)
        }
        transitioning()
        // ????
//        XCTAssertNil(weakModalVC, "WeakModalVC should be nil after dismiss.")
//        XCTAssertNil(mainVC?.tr_transition, "TRTRansition should be nil after dismiss.")
    }
    
}

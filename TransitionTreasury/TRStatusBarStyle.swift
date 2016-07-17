//
//  TRStatusBarStyle.swift
//  TransitionTreasury
//
//  Created by DianQK on 1/11/16.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import UIKit
/**
 TransitionTreasury Status Bar Style.
 */
public enum TRStatusBarStyle {
    case Default
    @available(iOS 7.0, *)
    case LightContent
    case Hide
    
    func updateStatusBarStyle(animated: Bool = true) {
        switch self {
        case .Default :
            UIApplication.shared().setStatusBarHidden(false, with: .fade)
            UIApplication.shared().setStatusBarStyle(.default, animated: animated)
        case .LightContent :
            UIApplication.shared().setStatusBarHidden(false, with: .fade)
            UIApplication.shared().setStatusBarStyle(.lightContent, animated: animated)
        case .Hide :
            UIApplication.shared().setStatusBarHidden(true, with: .fade)
        }
    }
    
    static func ConvertToTRStatusBarStyle(statusBarStyle: UIStatusBarStyle, statusBarHidden: Bool = UIApplication.shared().isStatusBarHidden) -> TRStatusBarStyle {
        guard statusBarHidden == false else {
            return .Hide
        }
        switch statusBarStyle {
        case .lightContent :
            return .LightContent
        case .default :
            return .Default
        default :
            fatalError("No support this status bar style")
        }
    }
    
    static func CurrentlyTRStatusBarStyle() -> TRStatusBarStyle {
        return ConvertToTRStatusBarStyle(statusBarStyle: UIApplication.shared().statusBarStyle)
    }
}

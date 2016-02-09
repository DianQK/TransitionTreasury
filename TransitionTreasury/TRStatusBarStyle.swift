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
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
            UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: animated)
        case .LightContent :
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
            UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: animated)
        case .Hide :
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
        }
    }
    
    static func ConvertToTRStatusBarStyle(statusBarStyle: UIStatusBarStyle, statusBarHidden: Bool = UIApplication.sharedApplication().statusBarHidden) -> TRStatusBarStyle {
        guard statusBarHidden == false else {
            return .Hide
        }
        switch statusBarStyle {
        case .LightContent :
            return .LightContent
        case .Default :
            return .Default
        default :
            fatalError("No support this status bar style")
        }
    }
    
    static func CurrentlyTRStatusBarStyle() -> TRStatusBarStyle {
        return ConvertToTRStatusBarStyle(UIApplication.sharedApplication().statusBarStyle)
    }
}
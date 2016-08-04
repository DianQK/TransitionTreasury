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
    case `default`
    @available(iOS 7.0, *)
    case lightContent
    case hide
    
    func updateStatusBarStyle(_ animated: Bool = true) {
        switch self {
        case .default :
            UIApplication.shared.setStatusBarHidden(false, with: .fade)
            UIApplication.shared.setStatusBarStyle(.default, animated: animated)
        case .lightContent :
            UIApplication.shared.setStatusBarHidden(false, with: .fade)
            UIApplication.shared.setStatusBarStyle(.lightContent, animated: animated)
        case .hide :
            UIApplication.shared.setStatusBarHidden(true, with: .fade)
        }
    }
    
    static func convertTo(statusBarStyle: UIStatusBarStyle, statusBarHidden: Bool = UIApplication.shared.isStatusBarHidden) -> TRStatusBarStyle {
        guard statusBarHidden == false else {
            return .hide
        }
        switch statusBarStyle {
        case .lightContent :
            return .lightContent
        case .default :
            return .default
        default :
            fatalError("No support this status bar style")
        }
    }
    
    static func currentlyTRStatusBarStyle() -> TRStatusBarStyle {
        return convertTo(statusBarStyle: UIApplication.shared.statusBarStyle)
    }
}

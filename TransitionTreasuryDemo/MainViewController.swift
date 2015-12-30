//
//  MainTableViewController.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/30/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
import TransitionTreasury

struct PushTransition {
    let name: String
    let pushMethod: TRPushMethod
}

struct PresentTransition {
    let name: String
    let presentMethod: TRPresentMethod
}

class MainTableViewController: UITableViewController, ModalViewControllerDelegate {
    
    var tr_transition: TRViewControllerTransitionDelegate?
    
    var pushTransition = [PushTransition]()

    var presentTransition = [PresentTransition]()
    
    func loadTransition() {
        presentTransition.append(PresentTransition(name: "Twitter", presentMethod: .Twitter))
        presentTransition.append(PresentTransition(name: "Fade", presentMethod: .Fade))
        presentTransition.append(PresentTransition(name: "PopTip", presentMethod: .PopTip(visibleHeight: 500)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTransition()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return pushTransition.count
        case 1: return presentTransition.count
        default: return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = presentTransition[indexPath.row].name

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Push & Pop"
        case 1: return "Present & Dismiss"
        default: return nil
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0 :
            print("0")
        case 1 :
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalViewController") as! ModalViewController
            vc.modalDelegate = self
            vc.title = presentTransition[indexPath.row].name
            let nav = UINavigationController(rootViewController: vc)
            tr_presentViewController(nav, method: presentTransition[indexPath.row].presentMethod, completion: nil)
        default :
            print("Nothing happened.")
        }
    }
    
    // MARK: - Modal viewController delegate
    
    func modalViewControllerDismiss(callbackData data:Dictionary<String,AnyObject>? = nil) {
        print("CallbackData: \(data)")
        tr_dismissViewController()
    }

}

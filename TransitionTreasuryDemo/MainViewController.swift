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

class MainViewController: UIViewController, ModalViewControllerDelegate {
    
    var tr_transition: TRViewControllerTransitionDelegate?
    
    var pushTransition = [PushTransition]()

    var presentTransition = [PresentTransition]()
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var presentResultLabel: UILabel!
    
    func loadTransition() {
        pushTransition.append(PushTransition(name: "OmniFocus", pushMethod: .OMIN(keyView: logoImageView)))
        pushTransition.append(PushTransition(name: "IBanTang", pushMethod: .IBanTang(keyView: logoImageView)))
        pushTransition.append(PushTransition(name: "Fade", pushMethod: .Fade))
        pushTransition.append(PushTransition(name: "Page", pushMethod: .Page))
        pushTransition.append(PushTransition(name: "Blixt", pushMethod: .Blixt(keyView: logoImageView, to: CGRect(x: 30, y: 360, width: logoImageView.frame.size.width / 3, height: logoImageView.frame.size.height / 3))))
        
        presentTransition.append(PresentTransition(name: "Twitter", presentMethod: .Twitter))
        presentTransition.append(PresentTransition(name: "Fade", presentMethod: .Fade))
        presentTransition.append(PresentTransition(name: "PopTip", presentMethod: .PopTip(visibleHeight: 500)))
        presentTransition.append(PresentTransition(name: "TaaskyFlip", presentMethod: .TaaskyFlip(blurEffect: true)))
        presentTransition.append(PresentTransition(name: "Elevate", presentMethod: .Elevate(maskView: logoImageView, to: UIScreen.mainScreen().center)))
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTransition()
        
        navigationController?.navigationBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Modal viewController delegate
    
    func modalViewControllerDismiss(callbackData data:Dictionary<String,AnyObject>? = nil) {
        presentResultLabel.text = "CallbackData: \(data)."
        tr_dismissViewController()
        
    }

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return pushTransition.count
        case 1: return presentTransition.count
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        switch indexPath.section {
        case 0 :
            cell.textLabel?.text = pushTransition[indexPath.row].name
        case 1:
            cell.textLabel?.text = presentTransition[indexPath.row].name
        default:
            cell.textLabel?.text = "Default"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Push & Pop"
        case 1: return "Present & Dismiss"
        default: return nil
        }
    }
    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 0 :
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SecondViewController") as! SecondViewController
            vc.title = pushTransition[indexPath.row].name
            navigationController?.tr_pushViewController(vc, method: pushTransition[indexPath.row].pushMethod, completion: {
                print("Push finished.")
            })
        case 1 :
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalViewController") as! ModalViewController
            vc.modalDelegate = self
            vc.title = presentTransition[indexPath.row].name
            let nav = UINavigationController(rootViewController: vc)
            tr_presentViewController(nav, method: presentTransition[indexPath.row].presentMethod, completion: {
                print("Present finished.")
            })
        default :
            print("Nothing happened.")
        }
    }
}

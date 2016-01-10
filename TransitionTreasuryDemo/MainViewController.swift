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
    let imageName: String
    let pushMethod: TRPushMethod
}

struct PresentTransition {
    let name: String
    let imageName: String
    let presentMethod: TRPresentMethod
}

class MainViewController: UIViewController, ModalViewControllerDelegate {
    
    var tr_transition: TRViewControllerTransitionDelegate?
    
    var pushTransition = [PushTransition]()

    var presentTransition = [PresentTransition]()
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var presentResultLabel: UILabel!
    
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
    
    func loadTransition() {
        pushTransition.append(PushTransition(name: "OmniFocus", imageName: "OmniFocus60x60", pushMethod: .OMIN(keyView: logoImageView)))
        pushTransition.append(PushTransition(name: "IBanTang", imageName: "IBanTang60x60", pushMethod: .IBanTang(keyView: logoImageView)))
        pushTransition.append(PushTransition(name: "Fade", imageName: "WeChat60x60", pushMethod: .Fade))
        pushTransition.append(PushTransition(name: "Page", imageName: "MeituanMovie60x60", pushMethod: .Page))
        pushTransition.append(PushTransition(name: "Blixt", imageName: "Blixt60x60", pushMethod: .Blixt(keyView: logoImageView, to: CGRect(x: 30, y: 360, width: logoImageView.frame.size.width / 3, height: logoImageView.frame.size.height / 3))))
        pushTransition.append(PushTransition(name: "Storehouse", imageName: "Storehouse60x60", pushMethod: .Storehouse(keyView: logoImageView)))
        
        presentTransition.append(PresentTransition(name: "Twitter", imageName: "Twitter60x60", presentMethod: .Twitter))
        presentTransition.append(PresentTransition(name: "Fade", imageName: "WeChat60x60", presentMethod: .Fade))
        presentTransition.append(PresentTransition(name: "PopTip", imageName: "Alipay60x60", presentMethod: .PopTip(visibleHeight: 500)))
        presentTransition.append(PresentTransition(name: "TaaskyFlip", imageName: "Taasky60x60", presentMethod: .TaaskyFlip(blurEffect: true)))
        presentTransition.append(PresentTransition(name: "Elevate", imageName: "Elevate60x60", presentMethod: .Elevate(maskView: logoImageView, to: UIScreen.mainScreen().center)))
        
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
            cell.imageView?.image = UIImage(named: pushTransition[indexPath.row].imageName)
        case 1:
            cell.textLabel?.text = presentTransition[indexPath.row].name
            cell.imageView?.image = UIImage(named: presentTransition[indexPath.row].imageName)
        default:
            cell.textLabel?.text = "Default"
        }
        cell.imageView?.contentMode = .ScaleToFill
        
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
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else { return }
        switch indexPath.section {
        case 0 :
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SecondViewController") as! SecondViewController
            vc.title = pushTransition[indexPath.row].name
            let updateTransition: TRPushMethod = {
                switch self.pushTransition[indexPath.row].name {
                case "OmniFocus" :
                    return .OMIN(keyView: cell)
                case "IBanTang" :
                    return .IBanTang(keyView: cell)
                case "Blixt" :
                    return .Blixt(keyView: cell.imageView!, to: CGRect(x: 30, y: 160, width: cell.imageView!.frame.size.width * 3, height: cell.imageView!.frame.size.height * 3))
                case "Storehouse" :
                    return .Storehouse(keyView: cell)
                default :
                    return self.pushTransition[indexPath.row].pushMethod
                }
            }()
            navigationController?.tr_pushViewController(vc, method: updateTransition, completion: {
                print("Push finished.")
            })
        case 1 :
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalViewController") as! ModalViewController
            vc.modalDelegate = self
            vc.title = presentTransition[indexPath.row].name
            let nav = UINavigationController(rootViewController: vc)
            let updateTransition: TRPresentMethod = {
                switch self.presentTransition[indexPath.row].name {
                case "Elevate" :
                    return .Elevate(maskView: cell.imageView!, to: UIScreen.mainScreen().center)
                default :
                    return self.presentTransition[indexPath.row].presentMethod
                }
            }()
            tr_presentViewController(nav, method: updateTransition, completion: {
                print("Present finished.")
            })
        default :
            print("Nothing happened.")
        }
    }
}

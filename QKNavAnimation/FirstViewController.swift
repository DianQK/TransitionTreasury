//
//  FirstViewController.swift
//  QKNavAnimation
//
//  Created by 宋宋 on 12/13/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, MainPresentDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func qk_presentVC(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SecondViewController") as! SecondViewController
        navigationController?.pushViewController(vc, animated: true)
//        vc.modalDelegate = self
       // let nav = UINavigationController(rootViewController: vc)
//        let nav = QKNavViewController(rootViewController: vc)
//        qk_presentViewController(nav, method: .Twitter, completion: nil)
//        presentViewController(nav, animated: true, completion: nil)
    }
    
    @IBAction func defaultDismissVC(sender: UIBarButtonItem) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dismissVC(sender: UIBarButtonItem) {
        qk_dismissViewController()
//        navigationController?.qk_dismissViewController()
//        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("deinit")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

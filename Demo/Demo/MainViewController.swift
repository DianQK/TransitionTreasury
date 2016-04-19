//
//  MainTableViewController.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/30/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
import TransitionTreasury
import TransitionAnimation

enum DemoTransition {
	case FadePush
	case TwitterPresent
	case SlideTabBar
}

extension DemoTransition: TransitionAnimationable {
	func transitionAnimation() -> TRViewControllerAnimatedTransitioning {
		switch self {
		case .FadePush:
			return FadeTransitionAnimation()
		case .TwitterPresent:
			return TwitterTransitionAnimation()
		case .SlideTabBar:
			return SlideTransitionAnimation()
		}
	}
}

struct PushTransition {
	let name: String
	let imageName: String
	let pushMethod: TRPushTransitionMethod
	let interactive: Bool
}

struct PresentTransition {
	let name: String
	let imageName: String
	let presentMethod: TRPresentTransitionMethod
	let interactive: Bool
}

class MainViewController: UIViewController, ModalTransitionDelegate {
	var tr_presentTransition: TRViewControllerTransitionDelegate?

	var pushTransition = [PushTransition]()

	var presentTransition = [PresentTransition]()

	@IBOutlet weak var logoImageView: UIImageView!

	@IBOutlet weak var presentResultLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()

		loadTransition()

		navigationController?.navigationBarHidden = true
	}

	// MARK: - Modal viewController delegate

	func modalViewControllerDismiss(callbackData data: AnyObject? = nil) {
		presentResultLabel.text = "CallbackData: \(data?["title"] as? String ?? "")."
		tr_dismissViewController(completion: {
			print("Dismiss finished.")
		})
	}

	func loadTransition() {
		pushTransition.append(PushTransition(name: "OmniFocus", imageName: "OmniFocus60x60", pushMethod: .OMNI(keyView: logoImageView), interactive: false))
		pushTransition.append(PushTransition(name: "IBanTang", imageName: "IBanTang60x60", pushMethod: .IBanTang(keyView: logoImageView), interactive: false))
		pushTransition.append(PushTransition(name: "Fade", imageName: "WeChat60x60", pushMethod: .Fade, interactive: false))
		pushTransition.append(PushTransition(name: "Page", imageName: "MeituanMovie60x60", pushMethod: .Page, interactive: false))
		pushTransition.append(PushTransition(name: "Blixt", imageName: "Blixt60x60", pushMethod: .Blixt(keyView: logoImageView, to: CGRect(x: 30, y: 360, width: logoImageView.frame.size.width / 3, height: logoImageView.frame.size.height / 3)), interactive: false))
		pushTransition.append(PushTransition(name: "Default", imageName: "", pushMethod: .Default, interactive: false))

		presentTransition.append(PresentTransition(name: "Twitter", imageName: "Twitter60x60", presentMethod: .Twitter, interactive: false))
		presentTransition.append(PresentTransition(name: "Fade", imageName: "WeChat60x60", presentMethod: .Fade, interactive: false))
		presentTransition.append(PresentTransition(name: "PopTip", imageName: "Alipay60x60", presentMethod: .PopTip(visibleHeight: 500), interactive: false))
		presentTransition.append(PresentTransition(name: "TaaskyFlip", imageName: "Taasky60x60", presentMethod: .TaaskyFlip(blurEffect: true), interactive: false))
		presentTransition.append(PresentTransition(name: "Elevate", imageName: "Elevate60x60", presentMethod: .Elevate(maskView: logoImageView, to: UIScreen.mainScreen().tr_center), interactive: false))
		presentTransition.append(PresentTransition(name: "Scanbot", imageName: "Scanbot60x60", presentMethod: .Scanbot(present: nil, dismiss: nil), interactive: true))
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
		case 0:
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
		guard let cell = tableView.cellForRowAtIndexPath(indexPath) else {
			return }
		switch indexPath.section {
		case 0:
			guard pushTransition[indexPath.row].interactive == false else {
				let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("InteractiveViewController")
				navigationController?.pushViewController(vc, animated: true)
				return;
			}
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SecondViewController") as! SecondViewController
			vc.title = pushTransition[indexPath.row].name
			let updateTransition: TRPushTransitionMethod = {
				switch self.pushTransition[indexPath.row].name {
				case "OmniFocus":
					return .OMNI(keyView: cell)
				case "IBanTang":
					return .IBanTang(keyView: cell)
				case "Blixt":
					return .Blixt(keyView: cell.imageView!, to: CGRect(x: 30, y: 160, width: cell.imageView!.frame.size.width * 3, height: cell.imageView!.frame.size.height * 3))
				default:
					return self.pushTransition[indexPath.row].pushMethod
				}
			}()
			navigationController?.tr_pushViewController(vc, method: updateTransition, statusBarStyle: .LightContent, completion: {
				print("Push finished.")
			})
		case 1:
			guard presentTransition[indexPath.row].interactive == false else {
				let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("InteractiveViewController")
				navigationController?.pushViewController(vc, animated: true)
				return;
			}
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalViewController") as! ModalViewController
			vc.modalDelegate = self
			vc.title = presentTransition[indexPath.row].name
			let nav = UINavigationController(rootViewController: vc)
			let updateTransition: TRPresentTransitionMethod = {
				switch self.presentTransition[indexPath.row].name {
				case "Elevate":
					return .Elevate(maskView: cell.imageView!, to: UIScreen.mainScreen().tr_center)
				default:
					return self.presentTransition[indexPath.row].presentMethod
				}
			}()
			tr_presentViewController(nav, method: updateTransition, completion: {
				print("Present finished.")
			})
		default:
			print("Nothing happened.")
		}
	}
}

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
	case fadePush
	case twitterPresent
	case slideTabBar
}

extension DemoTransition: TransitionAnimationable {
	func transitionAnimation() -> TRViewControllerAnimatedTransitioning {
		switch self {
		case .fadePush:
			return FadeTransitionAnimation()
		case .twitterPresent:
			return TwitterTransitionAnimation()
		case .slideTabBar:
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

		navigationController?.isNavigationBarHidden = true
	}

	// MARK: - Modal viewController delegate

	func modalViewControllerDismiss(callbackData data: AnyObject? = nil) {
		presentResultLabel.text = "CallbackData: \(data?["title"] as? String ?? "")."
		tr_dismissViewController(completion: {
			print("Dismiss finished.")
		})
	}

	func loadTransition() {
		pushTransition.append(PushTransition(name: "OmniFocus", imageName: "OmniFocus60x60", pushMethod: .omni(keyView: logoImageView), interactive: false))
		pushTransition.append(PushTransition(name: "IBanTang", imageName: "IBanTang60x60", pushMethod: .iBanTang(keyView: logoImageView), interactive: false))
		pushTransition.append(PushTransition(name: "Fade", imageName: "WeChat60x60", pushMethod: .fade, interactive: false))
		pushTransition.append(PushTransition(name: "Page", imageName: "MeituanMovie60x60", pushMethod: .page, interactive: false))
		pushTransition.append(PushTransition(name: "Blixt", imageName: "Blixt60x60", pushMethod: .blixt(keyView: logoImageView, to: CGRect(x: 30, y: 360, width: logoImageView.frame.size.width / 3, height: logoImageView.frame.size.height / 3)), interactive: false))
		pushTransition.append(PushTransition(name: "Default", imageName: "", pushMethod: .default, interactive: false))

		presentTransition.append(PresentTransition(name: "Twitter", imageName: "Twitter60x60", presentMethod: .twitter, interactive: false))
		presentTransition.append(PresentTransition(name: "Fade", imageName: "WeChat60x60", presentMethod: .fade, interactive: false))
		presentTransition.append(PresentTransition(name: "PopTip", imageName: "Alipay60x60", presentMethod: .popTip(visibleHeight: 500), interactive: false))
		presentTransition.append(PresentTransition(name: "TaaskyFlip", imageName: "Taasky60x60", presentMethod: .taaskyFlip(blurEffect: true), interactive: false))
		presentTransition.append(PresentTransition(name: "Elevate", imageName: "Elevate60x60", presentMethod: .elevate(maskView: logoImageView, to: UIScreen.main.tr_center), interactive: false))
		presentTransition.append(PresentTransition(name: "Scanbot", imageName: "Scanbot60x60", presentMethod: .scanbot(present: nil, dismiss: nil), interactive: true))
	}
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
	// MARK: - Table view data source

	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0: return pushTransition.count
		case 1: return presentTransition.count
		default: return 0
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

		switch (indexPath as NSIndexPath).section {
		case 0:
			cell.textLabel?.text = pushTransition[(indexPath as NSIndexPath).row].name
			cell.imageView?.image = UIImage(named: pushTransition[(indexPath as NSIndexPath).row].imageName)
		case 1:
			cell.textLabel?.text = presentTransition[(indexPath as NSIndexPath).row].name
			cell.imageView?.image = UIImage(named: presentTransition[(indexPath as NSIndexPath).row].imageName)
		default:
			cell.textLabel?.text = "Default"
		}
		cell.imageView?.contentMode = .scaleToFill

		return cell
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0: return "Push & Pop"
		case 1: return "Present & Dismiss"
		default: return nil
		}
	}

	// MARK: - Table view delegate

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard let cell = tableView.cellForRow(at: indexPath) else {
			return }
		switch (indexPath as NSIndexPath).section {
		case 0:
			guard pushTransition[(indexPath as NSIndexPath).row].interactive == false else {
				let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InteractiveViewController")
				navigationController?.pushViewController(vc, animated: true)
				return;
			}
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
			vc.title = pushTransition[(indexPath as NSIndexPath).row].name
			let updateTransition: TRPushTransitionMethod = {
				switch self.pushTransition[indexPath.row].name {
				case "OmniFocus":
					return .omni(keyView: cell)
				case "IBanTang":
					return .iBanTang(keyView: cell)
				case "Blixt":
					return .blixt(keyView: cell.imageView!, to: CGRect(x: 30, y: 160, width: cell.imageView!.frame.size.width * 3, height: cell.imageView!.frame.size.height * 3))
				default:
					return self.pushTransition[indexPath.row].pushMethod
				}
			}()
            
			navigationController?.tr_pushViewController(vc, method: updateTransition, statusBarStyle: .lightContent, completion: {
				print("Push finished.")
			})
		case 1:
			guard presentTransition[(indexPath as NSIndexPath).row].interactive == false else {
				let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InteractiveViewController")
				navigationController?.pushViewController(vc, animated: true)
				return;
			}
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
			vc.modalDelegate = self
			vc.title = presentTransition[(indexPath as NSIndexPath).row].name
			let nav = UINavigationController(rootViewController: vc)
			let updateTransition: TRPresentTransitionMethod = {
				switch self.presentTransition[indexPath.row].name {
				case "Elevate":
					return .elevate(maskView: cell.imageView!, to: UIScreen.main.tr_center)
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

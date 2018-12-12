import UIKit

class BaseNavigationController: UINavigationController {
	// MARK: - Status Bar
	override var childForStatusBarStyle: UIViewController? {
		return topViewController
	}
	
	override var childForStatusBarHidden: UIViewController? {
		return topViewController
	}
}

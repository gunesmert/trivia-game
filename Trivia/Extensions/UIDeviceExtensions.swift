import UIKit

extension UIDevice {
	static var hasSmallScreenSize: Bool {
		return UIScreen.main.bounds.size.width <= 320.0
	}
}

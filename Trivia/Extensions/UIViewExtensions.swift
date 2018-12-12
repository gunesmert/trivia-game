import UIKit
import SnapKit

extension UIView {
	func bindFrameToSuperviewBounds() {
		guard let _ = self.superview else {
			assertionFailure("Error! `superview` was nil–call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
			return
		}
		
		snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
}

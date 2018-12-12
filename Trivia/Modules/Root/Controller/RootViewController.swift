import UIKit
import RxSwift

final class RootViewController: BaseViewController {
	// MARK: - Status Bar
	override var childForStatusBarStyle: UIViewController? {
		return children.last
	}
	
	override var childForStatusBarHidden: UIViewController? {
		return children.last
	}
}

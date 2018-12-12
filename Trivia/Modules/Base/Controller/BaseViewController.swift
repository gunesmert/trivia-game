import UIKit
import RxSwift

class BaseViewController: UIViewController {
	lazy var disposeBag = DisposeBag()
	
	// MARK: - Initializers
	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = ColorPalette.Primary.Light.background
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		setNeedsStatusBarAppearanceUpdate()
	}
	
	// MARK: - Status Bar
	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

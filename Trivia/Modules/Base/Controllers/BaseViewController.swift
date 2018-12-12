import UIKit
import RxSwift

private struct NavigationBarTextAttributes {
	public static var regular: [NSAttributedString.Key: Any] {
		var attributes = [NSAttributedString.Key: Any]()
		attributes[NSAttributedString.Key.font] = UIFont.preferredFont(forTextStyle: .headline)
		attributes[NSAttributedString.Key.foregroundColor] = ColorPalette.Primary.Light.text
		return attributes
	}
	
	public static var large: [NSAttributedString.Key: Any] {
		var attributes = [NSAttributedString.Key: Any]()
		attributes[NSAttributedString.Key.font] = UIFont.preferredFont(forTextStyle: .largeTitle)
		attributes[NSAttributedString.Key.foregroundColor] = ColorPalette.Primary.Light.text
		return attributes
	}
}

class BaseViewController: UIViewController {
	lazy var disposeBag = DisposeBag()
	
	// MARK: - Initializers
	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		updateLeftNavigationBarButtons()
		updateRightNavigationBarButtons()
	}
	
	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = ColorPalette.Primary.Light.background
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		updateNavigationBarAppearance()
		setNeedsStatusBarAppearanceUpdate()
	}
	
	// MARK: - Status Bar
	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
	
	// MARK: - Navigation Bar
	var shouldShowNavigationBar: Bool { return true }
	var shouldShowLargeNavigationBar: Bool { return true }
	var shouldShowShadowUnderNavigationBar: Bool { return true }
	
	private func updateNavigationBarAppearance() {
		guard let controller = navigationController else { return }
		navigationController?.setNavigationBarHidden(!shouldShowNavigationBar, animated: true)
		
		let navigationBar = controller.navigationBar
		if #available(iOS 11.0, *) {
			navigationBar.prefersLargeTitles = shouldShowLargeNavigationBar
			navigationItem.largeTitleDisplayMode = .automatic
			
			navigationBar.largeTitleTextAttributes = NavigationBarTextAttributes.large
		}
		
		navigationBar.titleTextAttributes = NavigationBarTextAttributes.regular
		
		navigationBar.barTintColor = ColorPalette.Primary.tint
		navigationBar.backgroundColor = ColorPalette.Primary.tint
		
		if shouldShowShadowUnderNavigationBar {
			navigationBar.shadowImage = nil
		} else {
			navigationBar.shadowImage = UIImage()
			navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		}
		
		navigationBar.isTranslucent = false
	}
	
	var leftNavigationItemBundles: [NavigationItemBundle] { return [] }
	private var leftNavigationBarButtons: [NavigationBarButton] = []
	
	func updateLeftNavigationBarButtons() {
		if leftNavigationItemBundles.count > 0 {
			let items = navigationItems(withBundles: leftNavigationItemBundles)
			leftNavigationBarButtons = items.buttons
			leftNavigationBarButtons.forEach({ $0.contentHorizontalAlignment = .left })
			navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: items.view)]
		} else {
			navigationItem.setHidesBackButton(true, animated: true)
			navigationItem.leftBarButtonItems = nil
		}
	}
	
	var rightNavigationItemBundles: [NavigationItemBundle] { return [] }
	private var rightNavigationBarButtons: [NavigationBarButton] = []
	
	func updateRightNavigationBarButtons() {
		if rightNavigationItemBundles.count > 0 {
			let items = navigationItems(withBundles: rightNavigationItemBundles)
			rightNavigationBarButtons = items.buttons
			rightNavigationBarButtons.forEach({ $0.contentHorizontalAlignment = .right })
			navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: items.view)]
		} else {
			navigationItem.rightBarButtonItems = nil
		}
	}
	
	private func navigationItems(withBundles bundles: [NavigationItemBundle])
		-> (view: UIView, buttons: [NavigationBarButton]) {
			let holderView = UIView()
			var buttons: [NavigationBarButton] = []
			var totalWidth: CGFloat = 0.0
			
			bundles.forEach { (bundle) in
				let width = bundle.width
				
				let button = NavigationBarButton(withBundle: bundle)
				button.frame = CGRect(x: totalWidth, y: 0.0, width: width, height: 44.0)
				button.addTarget(self,
								 action: #selector(navigationBarButtonTapped(_:)),
								 for: UIControl.Event.touchUpInside)
				
				totalWidth += width
				
				holderView.addSubview(button)
				buttons.append(button)
			}
			
			holderView.frame = CGRect(x: 0.0, y: 0.0, width: totalWidth, height: 44.0)
			return (holderView, buttons)
	}
	
	@objc func navigationBarButtonTapped(_ button: NavigationBarButton) {
		
	}
}

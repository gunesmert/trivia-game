import UIKit

final class NavigationBarButton: UIButton {
	static let font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout)
	let bundle: NavigationItemBundle
	
	// MARK: - Constructors
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(withBundle bundle: NavigationItemBundle) {
		self.bundle = bundle
		super.init(frame: CGRect.zero)
		
		setImage(bundle.image, for: UIControl.State.normal)
		setTitle(bundle.title, for: UIControl.State.normal)
		setTitleColor(ColorPalette.Primary.Light.text, for: UIControl.State.normal)
		tintColor = ColorPalette.Primary.navigationBarButtonTint
		titleLabel?.font = NavigationBarButton.font
		adjustsImageWhenHighlighted = false
	}
}

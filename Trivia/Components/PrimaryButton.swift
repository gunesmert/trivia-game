import UIKit

final class PrimaryButton: UIButton {
	// MARK: - Initializers
	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = ColorPalette.Primary.buttonBackground
		setTitleColor(ColorPalette.Primary.Light.text, for: UIControl.State.normal)
		adjustsImageWhenHighlighted = false
		layer.cornerRadius = Constants.defaultCornerRadius
		layer.masksToBounds = true
	}
}

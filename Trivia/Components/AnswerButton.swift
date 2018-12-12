import UIKit

enum AnswerButtonState {
	case `default`
	case selected
	case correct
	case incorrect
	
	var backgroundColor: UIColor? {
		switch self {
		case .default:
			return ColorPalette.Answer.default
		case .selected:
			return ColorPalette.Answer.selected
		case .correct:
			return ColorPalette.Answer.correct
		case .incorrect:
			return ColorPalette.Answer.incorrect
		}
	}
}

final class AnswerButton: UIButton {
	var buttonState: AnswerButtonState = AnswerButtonState.default {
		didSet {
			updateInterface()
		}
	}
	
	// MARK: - Initializers
	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setTitleColor(ColorPalette.Primary.Light.text, for: UIControl.State.normal)
		adjustsImageWhenHighlighted = false
		layer.cornerRadius = Constants.defaultCornerRadius
		layer.masksToBounds = true
		titleLabel?.numberOfLines = 0
		titleLabel?.adjustsFontSizeToFitWidth = true
	}
	
	// MARK: - Helper
	private func updateInterface() {
		backgroundColor = buttonState.backgroundColor
	}
}

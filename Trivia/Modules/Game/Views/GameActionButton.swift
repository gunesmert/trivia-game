import UIKit

enum GameActionButtonState {
	case displayAnswer
	case nextQuestionIn(Int)
	case correctAnswer
	case incorrectAnswer
	case gameFinished
	
	var title: String {
		switch self {
		case .displayAnswer:
			return NSLocalizedString("Display Answer", comment: "")
		case .nextQuestionIn(let second):
			return String(format: NSLocalizedString("Next Question In %d", comment: ""), second)
		case .correctAnswer:
			return NSLocalizedString("Correct 🤩", comment: "")
		case .incorrectAnswer:
			return NSLocalizedString("Incorrect 😶", comment: "")
		case .gameFinished:
			return NSLocalizedString("🏁", comment: "")
		}
	}
	
	var backgroundColor: UIColor? {
		switch self {
		case .displayAnswer:
			return ColorPalette.GameAction.displayAnswer
		case .nextQuestionIn:
			return ColorPalette.GameAction.nextQuestion
		case .correctAnswer:
			return ColorPalette.GameAction.correctAnswer
		case .incorrectAnswer:
			return ColorPalette.GameAction.incorrectAnswer
		case .gameFinished:
			return ColorPalette.GameAction.gameFinished
		}
	}
}

final class GameActionButton: UIButton {
	var buttonState: GameActionButtonState = GameActionButtonState.displayAnswer {
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
		setTitle(buttonState.title, for: UIControl.State.normal)
	}
}

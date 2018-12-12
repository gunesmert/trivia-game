import UIKit
import SnapKit

final class GameView: UIView {
	weak var delegate: GameViewDelegate?
	
	lazy var questionNumberLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)
		label.textColor = ColorPalette.Primary.Light.text
		label.textAlignment = NSTextAlignment.center
		
		label.setContentHuggingPriority(UILayoutPriority.defaultHigh,
										for: NSLayoutConstraint.Axis.vertical)
		label.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh,
													  for: NSLayoutConstraint.Axis.vertical)
		
		return label
	}()
	
	lazy var questionSentenceLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
		label.textColor = ColorPalette.Primary.Light.text
		label.textAlignment = NSTextAlignment.center
		label.numberOfLines = 0
		
		label.setContentHuggingPriority(UILayoutPriority.defaultLow,
										for: NSLayoutConstraint.Axis.vertical)
		label.setContentCompressionResistancePriority(UILayoutPriority.defaultLow,
													  for: NSLayoutConstraint.Axis.vertical)
		
		return label
	}()
	
	private lazy var answersStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.distribution = UIStackView.Distribution.fillEqually
		stackView.axis = NSLayoutConstraint.Axis.vertical
		stackView.spacing = Constants.defaultSpacing
		return stackView
	}()
	
	// MARK: - Initializers
	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = ColorPalette.Primary.Light.background
		
		addSubview(answersStackView)
		answersStackView.snp.makeConstraints { make in
			make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(Constants.defaultMargin * 2)
			make.leading.trailing.equalToSuperview().inset(Constants.defaultMargin * 2)
			make.height.equalTo(0.0)
		}
		
		addSubview(questionNumberLabel)
		questionNumberLabel.snp.makeConstraints { make in
			make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(Constants.defaultMargin)
			make.leading.trailing.equalToSuperview().inset(Constants.defaultMargin)
		}
		
		addSubview(questionSentenceLabel)
		questionSentenceLabel.snp.makeConstraints { make in
			make.top.equalTo(questionNumberLabel.snp.bottom)
			make.leading.trailing.equalToSuperview().inset(Constants.defaultMargin)
			make.bottom.equalTo(answersStackView.snp.top)
		}
	}
	
	// MARK: - Methods
	func updateInterface(with answers: [String]) {
		answersStackView.arrangedSubviews.forEach({
			answersStackView.removeArrangedSubview($0)
			$0.removeFromSuperview()
		})
		
		for answer in answers {
			let button = AnswerButton()
			button.buttonState = AnswerButtonState.default
			button.setTitle(answer, for: UIControl.State.normal)
			button.addTarget(self,
							 action: #selector(buttonTapped(_:)),
							 for: UIControl.Event.touchUpInside)
			
			answersStackView.addArrangedSubview(button)
		}
		
		var height = CGFloat(answers.count) * Constants.minimumDimension
		height += CGFloat(answers.count) * answersStackView.spacing
		
		answersStackView.snp.updateConstraints { update in
			update.height.equalTo(height)
		}
	}
	
	func updateInterface(with selectedAnswerIndex: Int) {
		guard let buttons = answersStackView.arrangedSubviews as? [AnswerButton] else { return }
		buttons[selectedAnswerIndex].buttonState = AnswerButtonState.selected
	}
	
	func updateInterface(with selectedAnswerIndex: Int, and correctAnswerIndex: Int) {
		guard let buttons = answersStackView.arrangedSubviews as? [AnswerButton] else { return }
		for (index, button) in buttons.enumerated() {
			if index == selectedAnswerIndex {
				button.buttonState = AnswerButtonState.incorrect
			}
			
			if index == correctAnswerIndex {
				button.buttonState = AnswerButtonState.correct
			}
		}
	}
	
	// MARK: - Helper Methods
	private func index(of answerButton: AnswerButton) -> Int? {
		guard let buttons = answersStackView.arrangedSubviews as? [AnswerButton] else { return nil }
		for (index, button) in buttons.enumerated() { if button === answerButton { return index } }
		return nil
	}
	
	// MARK: - Actions
	@objc func buttonTapped(_ answerButton: AnswerButton) {
		guard let index = index(of: answerButton) else { return }
		let action = GameViewDelegateAction.didReceiveTap(index)
		delegate?.gameView(self, didTrigger: action)
	}
}

enum GameViewDelegateAction {
	case didReceiveTap(Int)
}

// MARK: - MainViewDelegate
protocol GameViewDelegate: class {
	func gameView(_ view: GameView, didTrigger action: GameViewDelegateAction)
}

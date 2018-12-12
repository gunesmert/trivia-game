import UIKit
import SnapKit

enum GameComponentsViewState {
	case loading
	case newQuestion(String, String, [String]) // questionNumber, questionSentence, answers
	case selectedAnswer(Int)
	case highlightAnswer(Int, Int) // selectedIndex, correctAnswerIndex
	case gameFinished
}

final class GameComponentsView: UIView {
	let gameView = GameView()
	
	private lazy var activityIndicatorHolderView: UIView = {
		let view = UIView()
		view.backgroundColor = ColorPalette.Primary.Light.background
		view.isHidden = true
		return view
	}()
	
	private lazy var activityIndicatorView: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
		view.color = ColorPalette.Primary.tint
		view.hidesWhenStopped = true
		return view
	}()
	
	var state: GameComponentsViewState = .loading {
		didSet {
			updateInterface(with: state)
		}
	}
	
	// MARK: - Initializers
	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = ColorPalette.Primary.Light.background
		
		addSubview(gameView)
		gameView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		addSubview(activityIndicatorHolderView)
		activityIndicatorHolderView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		activityIndicatorHolderView.addSubview(activityIndicatorView)
		activityIndicatorView.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
		}
	}
	
	// MARK: - Interface
	private func updateInterface(with state: GameComponentsViewState) {
		switch state {
		case .loading:
			bringSubviewToFront(activityIndicatorHolderView)
			activityIndicatorHolderView.isHidden = false
			activityIndicatorView.startAnimating()
		case .newQuestion(let questionNumberText, let questionSentence, let answers):
			bringSubviewToFront(gameView)
			activityIndicatorHolderView.isHidden = true
			activityIndicatorView.stopAnimating()
			gameView.questionNumberLabel.text = questionNumberText
			gameView.questionSentenceLabel.text = questionSentence
			gameView.updateInterface(with: answers)
			gameView.isHidden = false
		case .selectedAnswer(let selectedAnswerIndex):
			gameView.updateInterface(with: selectedAnswerIndex)
		case .highlightAnswer(let selectedAnswerIndex, let currentAnswerIndex):
			gameView.updateInterface(with: selectedAnswerIndex, and: currentAnswerIndex)
		case .gameFinished:
			break
		}
	}
}

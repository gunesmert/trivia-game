import RxSwift
import RxCocoa

protocol GameViewModel {
	var inputs: GameViewModelInputs { get }
	var outputs: GameViewModelOutputs { get }
	var navigationBarProperties: NavigationBarProperties { get }
}

final class DefaultGameViewModel: GameViewModel {
	weak var delegate: DefaultGameViewModelDelegate?
	
	var inputs: GameViewModelInputs { return self }
	var outputs: GameViewModelOutputs { return self }
	var navigationBarProperties: NavigationBarProperties { return self }
	
	private let repository: Repository
	private var categoriesInput = PublishSubject<[Category]>()
	private var alertViewModelInput = PublishSubject<AlertControllerViewModel>()
	private var navigationTitleInput = BehaviorSubject<String?>(value: nil)
	private var gameComponentsViewStateInput = PublishSubject<GameComponentsViewState>()
	private var gameActionButtonStateInput = PublishSubject<GameActionButtonState>()
	
	private let questionsBundle: Observable<QuestionsBundle>
	private let error: Observable<Error>
	
	private let questionsReloadInput: PublishSubject<Category?> = PublishSubject()
	
	private lazy var disposeBag = DisposeBag()
	
	private var category: Category?
	
	private var questions: [Question] = []
	private var currentQuestionIndex: Int = -1
	private var currentShuffledAnswers: [String] = []
	private var numberOfCorrectAnswers: Int = 0
	private var currentActionButtonState: GameActionButtonState {
		didSet {
			switch currentActionButtonState {
			case .displayAnswer:
				shouldProcessAnyButtonActions = true
			default:
				break
			}
			
			gameActionButtonStateInput.onNext(currentActionButtonState)
		}
	}
	private var shouldProcessAnyButtonActions: Bool = true
	private var countdownTimer: Timer?
	
	// MARK: - Initializers
	init(with repository: Repository, and category: Category? = nil) {
		self.repository = repository
		self.category = category
		self.currentActionButtonState = GameActionButtonState.displayAnswer
		
		let fetchQuestions = questionsReloadInput.flatMap { category in
			repository
				.fetchQuestions(with: category)
				.asObservable()
				.materialize()
			}.share()

		self.questionsBundle = fetchQuestions.elements().map { bundle in return bundle }
		self.error = fetchQuestions.errors().map { error in return error }

		self.questionsBundle
			.subscribe(
				onNext: { [weak self] bundle in
					self?.didReceiveQuestionsBundle(bundle)
				}
			)
			.disposed(by: disposeBag)

		self.error
			.subscribe(
				onNext: { [weak self] error in
					self?.displayError(error.localizedDescription)
				}
			)
			.disposed(by: disposeBag)
	}
	
	// MARK: - Helper Methods
	private func didReceiveQuestionsBundle(_ bundle: QuestionsBundle) {
		switch bundle.responseCode {
		case .success:
			questions = bundle.questions
			currentQuestionIndex = -1
			displayNextQuestionIfPossible()
		default:
			displayError(bundle.responseCode.localizedDescription)
		}
	}
	
	private func displayError(_ message: String) {
		let okTitle = NSLocalizedString("OK", comment: "")
		let okAction = AlertControllerViewModel.Action(title: okTitle, style: UIAlertAction.Style.default) { }
		
		let title = NSLocalizedString("Uh oh", comment: "")
		let model = AlertControllerViewModel(style: UIAlertController.Style.alert,
											 title: title,
											 message: message,
											 items: [okAction])
		
		alertViewModelInput.onNext(model)
	}
	
	private func displayNextQuestionIfPossible() {
		currentQuestionIndex += 1
		
		guard currentQuestionIndex < questions.count else {
			displayResultsAndEndGame()
			return
		}
		
		func displayNextQuestion() {
			currentActionButtonState = GameActionButtonState.displayAnswer
			
			let question = questions[currentQuestionIndex]
			currentShuffledAnswers = question.shuffledAnswers()
			
			let realQuestionIndex = currentQuestionIndex + 1
			let questionNumberText = String(format: NSLocalizedString("Question %d / %d", comment: ""), realQuestionIndex, questions.count)
			
			let state = GameComponentsViewState.newQuestion(questionNumberText,
															question.questionSentence,
															currentShuffledAnswers)
			gameComponentsViewStateInput.onNext(state)
		}
		
		if currentQuestionIndex == 0 {
			displayNextQuestion()
		} else {
			performCountdownFor(3) {
				displayNextQuestion()
			}
		}
	}
	
	private func performCountdownFor(_ seconds: Int, _ completion: @escaping () -> Void) {
		var count: Int = 0
		
		currentActionButtonState = GameActionButtonState.nextQuestionIn(seconds)
		
		self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
			count += 1
			
			if count == seconds {
				self.countdownTimer?.invalidate()
				self.countdownTimer = nil
				completion()
			} else {
				self.currentActionButtonState = GameActionButtonState.nextQuestionIn(seconds - count)
			}
		}
	}
	
	private func selectAnswer(at index: Int) {
		let state = GameComponentsViewState.selectedAnswer(index)
		gameComponentsViewStateInput.onNext(state)
	}
	
	private func highlightCorrectAnswer(at index: Int, selectedIndex: Int) {
		let state = GameComponentsViewState.highlightAnswer(selectedIndex, index)
		gameComponentsViewStateInput.onNext(state)
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
			self.displayNextQuestionIfPossible()
		}
	}
	
	private func displayResultsAndEndGame() {
		currentActionButtonState = GameActionButtonState.gameFinished
		
		let noTitle = NSLocalizedString("No", comment: "")
		let noAction = AlertControllerViewModel.Action(title: noTitle, style: UIAlertAction.Style.default) {
			self.endGame()
		}
		
		let yesTitle = NSLocalizedString("Yes", comment: "")
		let yesAction = AlertControllerViewModel.Action(title: yesTitle, style: UIAlertAction.Style.default) {
			self.restartGame()
		}
		
		let title = NSLocalizedString("Congratulations", comment: "")
		let message = String(format: NSLocalizedString("You have completed the game with %d correct answers. Here is a 🥔. Would you like to play again?", comment: ""), numberOfCorrectAnswers)
		let model = AlertControllerViewModel(style: UIAlertController.Style.alert,
											 title: title,
											 message: message,
											 items: [noAction, yesAction])
		
		alertViewModelInput.onNext(model)
	}
	
	private func endGame() {
		let action = DefaultGameViewModelDelegateAction.gameEnded
		delegate?.viewModel(self, didTrigger: action)
	}
	
	private func restartGame() {
		questions = []
		currentQuestionIndex = -1
		currentShuffledAnswers = []
		numberOfCorrectAnswers = 0
		
		gameComponentsViewStateInput.onNext(GameComponentsViewState.loading)
		currentActionButtonState = GameActionButtonState.displayAnswer
		questionsReloadInput.onNext(category)
	}
}

// MARK: - GameViewModelInputs
protocol GameViewModelInputs {
	func viewDidEndLoading()
	func crossButtonTapped()
	func didSelectAnswer(at index: Int)
	func actionButtonTapped()
}

extension DefaultGameViewModel: GameViewModelInputs {
	func viewDidEndLoading() {
		restartGame()
		
		if let category = category {
			navigationTitleInput.onNext(category.description)
		} else {
			navigationTitleInput.onNext(NSLocalizedString("Random Questions", comment: ""))
		}
	}
	
	func crossButtonTapped() {
		let noTitle = NSLocalizedString("No", comment: "")
		let noAction = AlertControllerViewModel.Action(title: noTitle, style: UIAlertAction.Style.default) { }
		
		let yesTitle = NSLocalizedString("Yes", comment: "")
		let yesAction = AlertControllerViewModel.Action(title: yesTitle, style: UIAlertAction.Style.default) {
			self.endGame()
		}
		
		let title = NSLocalizedString("Attention", comment: "")
		let message = NSLocalizedString("Seems like your current game has not ended yet. Would you still like to quit?", comment: "")
		let model = AlertControllerViewModel(style: UIAlertController.Style.alert,
											 title: title,
											 message: message,
											 items: [noAction, yesAction])
		
		alertViewModelInput.onNext(model)
	}
	
	func didSelectAnswer(at index: Int) {
		guard shouldProcessAnyButtonActions else { return }
		shouldProcessAnyButtonActions = false
		selectAnswer(at: index)
		
		let question = questions[currentQuestionIndex]
		guard let correctAnswerIndex = currentShuffledAnswers.index(of: question.correctAnswer) else { return }
		
		if correctAnswerIndex == index {
			numberOfCorrectAnswers += 1
		}
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
			if correctAnswerIndex == index {
				self.currentActionButtonState = GameActionButtonState.correctAnswer
			} else {
				self.currentActionButtonState = GameActionButtonState.incorrectAnswer
			}
			
			self.highlightCorrectAnswer(at: correctAnswerIndex, selectedIndex: index)
		}
	}
	
	func actionButtonTapped() {
		guard shouldProcessAnyButtonActions else { return }
		shouldProcessAnyButtonActions = false
		switch currentActionButtonState {
		case .displayAnswer:
			let question = questions[currentQuestionIndex]
			guard let correctAnswerIndex = currentShuffledAnswers.index(of: question.correctAnswer) else { return }
			
			gameComponentsViewStateInput.onNext(GameComponentsViewState.displayCorrectAnswer(correctAnswerIndex))
			
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
				self.displayNextQuestionIfPossible()
			}
		default:
			break
		}
	}
}

// MARK: - GameViewModelOutputs
protocol GameViewModelOutputs {
	var categories: Observable<[Category]> { get }
	var alertViewModel: Observable<AlertControllerViewModel> { get }
	var navigationTitle: Observable<String?> { get }
	var gameComponentsViewState: Observable<GameComponentsViewState> { get }
	var gameActionButtonState: Observable<GameActionButtonState> { get }
}

extension DefaultGameViewModel: GameViewModelOutputs {
	var categories: Observable<[Category]> { return categoriesInput.asObservable() }
	var alertViewModel: Observable<AlertControllerViewModel> { return alertViewModelInput.asObservable() }
	var navigationTitle: Observable<String?> { return navigationTitleInput.asObservable() }
	var gameComponentsViewState: Observable<GameComponentsViewState> {
		return gameComponentsViewStateInput.asObservable()
	}
	var gameActionButtonState: Observable<GameActionButtonState> {
		return gameActionButtonStateInput.asObservable()
	}
}

// MARK: - DefaultGameViewModelDelegate
enum DefaultGameViewModelDelegateAction {
	case gameEnded
}

protocol DefaultGameViewModelDelegate: class {
	func viewModel(_ viewModel: DefaultGameViewModel,
				   didTrigger action: DefaultGameViewModelDelegateAction)
}

// MARK: - NavigationBarProperties
extension DefaultGameViewModel: NavigationBarProperties {
	var shouldShowNavigationBar: Bool { return true }
	var shouldShowLargeNavigationBar: Bool { return false }
	var rightNavigationItemBundles: [NavigationItemBundle] {
		return [NavigationItemBundle(withType: NavigationItemType.cross)]
	}
}

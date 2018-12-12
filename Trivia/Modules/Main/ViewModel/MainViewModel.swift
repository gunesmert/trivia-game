import RxSwift
import RxCocoa

enum MainViewAction {
	case chooseCategory
	case playWithRandomQuestions
	case playWithLastCategory(Category)

	var title: String? {
		switch self {
		case .chooseCategory:
			return NSLocalizedString("Choose a Category to Play", comment: "")
		case .playWithRandomQuestions:
			return NSLocalizedString("Play with Random Questions", comment: "")
		case .playWithLastCategory(let category):
			return String(format: NSLocalizedString("Play %@", comment: ""), category.description)
		}
	}
}

protocol MainViewModel {
	var inputs: MainViewModelInputs { get }
	var outputs: MainViewModelOutputs { get }
}

final class DefaultMainViewModel: MainViewModel {
	weak var delegate: DefaultMainViewModelDelegate?
	
	var inputs: MainViewModelInputs { return self }
	var outputs: MainViewModelOutputs { return self }
	
	private let repository: Repository
	private var actionsInput = PublishSubject<[MainViewAction]>()
	private var alertViewModelInput = PublishSubject<AlertControllerViewModel>()
	
	private lazy var disposeBag = DisposeBag()
	
	private var currentActions: [MainViewAction] = [] {
		didSet {
			actionsInput.onNext(currentActions)
		}
	}
	
	// MARK: - Initializers
	init(with repository: Repository) {
		self.repository = repository
	}
}

// MARK: - MainViewModelInputs
protocol MainViewModelInputs {
	func viewDidEndLoading()
	func didReceiveTapForAction(at index: Int)
}

extension DefaultMainViewModel: MainViewModelInputs {
	func viewDidEndLoading() {
		currentActions = [MainViewAction.chooseCategory, MainViewAction.playWithRandomQuestions]
	}
	
	func didReceiveTapForAction(at index: Int) {
		guard index < currentActions.count else { return }
		
		switch currentActions[index] {
		case .chooseCategory:
			let action = DefaultMainViewModelDelegateAction.didSelectChooseCategory
			delegate?.viewModel(self, didTrigger: action)
		case .playWithRandomQuestions:
			let action = DefaultMainViewModelDelegateAction.didSelectPlayWithRandomQuestions
			delegate?.viewModel(self, didTrigger: action)
		case .playWithLastCategory(let category):
			let action = DefaultMainViewModelDelegateAction.didSelectCategory(category)
			delegate?.viewModel(self, didTrigger: action)
		}
	}
}

// MARK: - MainViewModelOutputs
protocol MainViewModelOutputs {
	var actions: Observable<[MainViewAction]> { get }
	var alertViewModel: Observable<AlertControllerViewModel> { get }
}

extension DefaultMainViewModel: MainViewModelOutputs {
	var actions: Observable<[MainViewAction]> { return actionsInput.asObservable() }
	var alertViewModel: Observable<AlertControllerViewModel> { return alertViewModelInput.asObservable() }
}

// MARK: - DefaultMainViewModelDelegate
enum DefaultMainViewModelDelegateAction {
	case didSelectChooseCategory
	case didSelectPlayWithRandomQuestions
	case didSelectCategory(Category)
}

protocol DefaultMainViewModelDelegate: class {
	func viewModel(_ viewModel: DefaultMainViewModel, didTrigger action: DefaultMainViewModelDelegateAction)
}

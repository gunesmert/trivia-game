import RxSwift
import RxCocoa

protocol ChooseCategoryViewModel {
	var inputs: ChooseCategoryViewModelInputs { get }
	var outputs: ChooseCategoryViewModelOutputs { get }
	var navigationBarProperties: NavigationBarProperties { get }
}

final class DefaultChooseCategoryViewModel: ChooseCategoryViewModel {
	weak var delegate: DefaultChooseCategoryViewModelDelegate?
	
	var inputs: ChooseCategoryViewModelInputs { return self }
	var outputs: ChooseCategoryViewModelOutputs { return self }
	var navigationBarProperties: NavigationBarProperties { return self }
	
	private let repository: Repository
	private var categoriesInput = PublishSubject<[Category]>()
	private var alertViewModelInput = PublishSubject<AlertControllerViewModel>()
	private var stateInput = BehaviorSubject<BaseComponentsViewState>(value: BaseComponentsViewState.idle)
	private lazy var navigationTitleInput = BehaviorSubject<String?>(value: nil)
	
	private let categoriesBundle: Observable<CategoriesBundle>
	private let error: Observable<Error>
	
	private let categoriesReloadInput: PublishSubject<()> = PublishSubject()
	
	private lazy var disposeBag = DisposeBag()
	
	private var currentCategories: [Category] = [] {
		didSet {
			categoriesInput.onNext(currentCategories)
		}
	}
	
	// MARK: - Initializers
	init(with repository: Repository) {
		self.repository = repository
		
		let fetchCategories = categoriesReloadInput.flatMap { bundle in
			repository
				.fetchCategories()
				.asObservable()
				.materialize()
			}.share()
		
		self.categoriesBundle = fetchCategories.elements().map { bundle in return bundle }
		self.error = fetchCategories.errors().map { error in return error }
		
		self.categoriesBundle
			.subscribe(
				onNext: { [weak self] bundle in
					self?.stateInput.onNext(BaseComponentsViewState.idle)
					self?.currentCategories = bundle.categories
				}
			)
			.disposed(by: disposeBag)
		
		self.error
			.subscribe(
				onNext: { [weak self] error in
					let message = error.localizedDescription + NSLocalizedString("\nTap to try again!", comment: "")
					self?.stateInput.onNext(BaseComponentsViewState.error(message))
				}
			)
			.disposed(by: disposeBag)
	}
}

// MARK: - ChooseCategoryViewModelInputs
protocol ChooseCategoryViewModelInputs {
	func viewDidEndLoading()
	func backButtonTapped()
	func emptyStateViewTapped()
	func didSelectCategory(at index: Int)
}

extension DefaultChooseCategoryViewModel: ChooseCategoryViewModelInputs {
	func viewDidEndLoading() {
		stateInput.onNext(BaseComponentsViewState.loading)
		categoriesReloadInput.onNext(())
		navigationTitleInput.onNext(NSLocalizedString("Select a Category", comment: ""))
	}
	
	func backButtonTapped() {
		let action = DefaultChooseCategoryViewModelDelegateAction.back
		delegate?.viewModel(self, didTrigger: action)
	}
	
	func emptyStateViewTapped() {
		stateInput.onNext(BaseComponentsViewState.loading)
		categoriesReloadInput.onNext(())
	}
	
	func didSelectCategory(at index: Int) {
		guard index < currentCategories.count else { return }
		let action = DefaultChooseCategoryViewModelDelegateAction.didSelectCategory(currentCategories[index])
		delegate?.viewModel(self, didTrigger: action)
	}
}

// MARK: - ChooseCategoryViewModelOutputs
protocol ChooseCategoryViewModelOutputs {
	var categories: Observable<[Category]> { get }
	var alertViewModel: Observable<AlertControllerViewModel> { get }
	var state: Observable<BaseComponentsViewState> { get }
	var navigationTitle: Observable<String?> { get }
}

extension DefaultChooseCategoryViewModel: ChooseCategoryViewModelOutputs {
	var categories: Observable<[Category]> { return categoriesInput.asObservable() }
	var alertViewModel: Observable<AlertControllerViewModel> { return alertViewModelInput.asObservable() }
	var state: Observable<BaseComponentsViewState> { return stateInput.asObservable() }
	var navigationTitle: Observable<String?> { return navigationTitleInput.asObservable() }
}

// MARK: - DefaultChooseCategoryViewModelDelegate
enum DefaultChooseCategoryViewModelDelegateAction {
	case back
	case didSelectCategory(Category)
}

protocol DefaultChooseCategoryViewModelDelegate: class {
	func viewModel(_ viewModel: DefaultChooseCategoryViewModel,
				   didTrigger action: DefaultChooseCategoryViewModelDelegateAction)
}

// MARK: - NavigationBarProperties
extension DefaultChooseCategoryViewModel: NavigationBarProperties {
	var shouldShowNavigationBar: Bool { return true }
	var shouldShowLargeNavigationBar: Bool { return true }
	var leftNavigationItemBundles: [NavigationItemBundle] {
		return [NavigationItemBundle(withType: NavigationItemType.back)]
	}
}

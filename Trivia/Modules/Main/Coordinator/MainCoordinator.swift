import UIKit
import RxSwift
import RxCocoa

final class MainCoordinator: Coordinator {
	private let repository: Repository
	private let categoryManager: CategoryManager = DefaultCategoryManager()
	
	private lazy var mainViewController: MainViewController = {
		let viewModel = DefaultMainViewModel(with: categoryManager)
		viewModel.delegate = self
		return MainViewController(viewModel: viewModel)
	}()
	
	lazy private(set) var viewController: UIViewController = {
		return BaseNavigationController(rootViewController: mainViewController)
	}()
	
	// MARK: - Initializers
	init(with repository: Repository) {
		self.repository = repository
	}
	
	// MARK: - Coordination
	private func displayChooseCategory() {
		guard let navigationController = viewController as? BaseNavigationController else { return }
		let viewModel = DefaultChooseCategoryViewModel(with: repository)
		viewModel.delegate = self
		let controller = ChooseCategoryViewController(viewModel: viewModel)
		navigationController.pushViewController(controller, animated: true)
	}
	
	private func startGame(with category: Category? = nil) {
		if let category = category {
			categoryManager.updateLatestUsedCategory(category)
		}
		guard let navigationController = viewController as? BaseNavigationController else { return }
		let viewModel = DefaultGameViewModel(with: repository, and: category)
		viewModel.delegate = self
		let controller = GameViewController(viewModel: viewModel)
		navigationController.pushViewController(controller, animated: true)
	}
}

// MARK: - DefaultMainViewModelDelegate
extension MainCoordinator: DefaultMainViewModelDelegate {
	func viewModel(_ viewModel: DefaultMainViewModel, didTrigger action: DefaultMainViewModelDelegateAction) {
		switch action {
		case .didSelectChooseCategory:
			displayChooseCategory()
		case .didSelectPlayWithRandomQuestions:
			startGame()
		case .didSelectCategory(let category):
			startGame(with: category)
		}
	}
}

// MARK: - DefaultChooseCategoryViewModelDelegate
extension MainCoordinator: DefaultChooseCategoryViewModelDelegate {
	func viewModel(_ viewModel: DefaultChooseCategoryViewModel,
				   didTrigger action: DefaultChooseCategoryViewModelDelegateAction) {
		switch action {
		case .back:
			guard let navigationController = viewController as? BaseNavigationController else { return }
			navigationController.popViewController(animated: true)
		case .didSelectCategory(let category):
			startGame(with: category)
		}
	}
}

// MARK: - DefaultGameViewModelDelegate
extension MainCoordinator: DefaultGameViewModelDelegate {
	func viewModel(_ viewModel: DefaultGameViewModel, didTrigger action: DefaultGameViewModelDelegateAction) {
		switch action {
		case .gameEnded:
			guard let navigationController = viewController as? BaseNavigationController else { return }
			navigationController.popToRootViewController(animated: true)
			// TODO: Update Main View Model for last played category
		}
	}
}

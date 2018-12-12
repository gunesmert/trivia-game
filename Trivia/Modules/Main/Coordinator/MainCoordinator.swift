import UIKit
import RxSwift
import RxCocoa

final class MainCoordinator: Coordinator {
	private let repository: Repository
	
	lazy private(set) var viewController: UIViewController = {
		let viewModel = DefaultMainViewModel(with: repository)
		viewModel.delegate = self
		return MainViewController(viewModel: viewModel)
	}()
	
	// MARK: - Initializers
	init(with repository: Repository) {
		self.repository = repository
	}
}

// MARK: - DefaultMainViewModelDelegate
extension MainCoordinator: DefaultMainViewModelDelegate {
	func viewModel(_ viewModel: DefaultMainViewModel, didTrigger action: DefaultMainViewModelDelegateAction) {
		switch action {
		case .didSelectChooseCategory:
			break
		case .didSelectPlayWithRandomQuestions:
			break
		case .didSelectCategory(let category):
			break
		}
	}
}

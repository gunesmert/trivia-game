import UIKit
import RxSwift
import RxCocoa

final class RootCoordinator: Coordinator {
	private var repository: Repository
	
	private lazy var mainCoordinator: MainCoordinator = {
		let coordinator = MainCoordinator(with: repository)
		return coordinator
	}()

	lazy private(set) var viewController: UIViewController = {
		return RootViewController()
	}()
	
	// MARK: - Initializers
	init(with repository: Repository) {
		self.repository = repository
		addChildCoordinator(mainCoordinator)
	}
	
	// MARK: - Coordination Methods
	private func addChildCoordinator(_ coordinator: Coordinator) {
		DispatchQueue.main.async { [weak self] in
			guard let strongSelf = self else { return }
			if strongSelf.viewController.children.contains(coordinator.viewController) { return }
			strongSelf.viewController.addChild(coordinator.viewController)
			strongSelf.viewController.view.addSubview(coordinator.viewController.view)
			coordinator.viewController.view.bindFrameToSuperviewBounds()
			coordinator.viewController.didMove(toParent: strongSelf.viewController)
		}
	}
	
	private func removeChildCoordinator(_ coordinator: Coordinator) {
		DispatchQueue.main.async {
			coordinator.viewController.willMove(toParent: nil)
			coordinator.viewController.view.removeFromSuperview()
			coordinator.viewController.removeFromParent()
		}
	}
}

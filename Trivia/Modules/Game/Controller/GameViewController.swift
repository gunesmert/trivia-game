import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class GameViewController: BaseViewController {
	private let viewModel: GameViewModel
	
	private lazy var gameComponentsView: GameComponentsView = {
		let view = GameComponentsView()
		view.gameView.delegate = self
		return view
	}()
	
	// MARK: - Initializers
	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	init(viewModel: GameViewModel) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - View Lifecycle
	override func loadView() {
		super.loadView()
		
		view.addSubview(gameComponentsView)
		gameComponentsView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		bind(to: viewModel)
		viewModel.inputs.viewDidEndLoading()
	}
	
	// MARK: - ViewModel
	private func bind(to viewModel: GameViewModel) {
		viewModel.outputs.navigationTitle
			.subscribe(
				onNext: { [weak self] title in
					self?.navigationItem.title = title
				}
			)
			.disposed(by: disposeBag)
		
		viewModel.outputs.alertViewModel
			.subscribe(
				onNext: { [weak self] alertViewModel in
					self?.presentAlert(with: alertViewModel)
				}
			)
			.disposed(by: disposeBag)
		
		viewModel.outputs.gameComponentsViewState
			.observeOn(MainScheduler.instance)
			.subscribe(
				onNext: { [weak self] state in
					self?.gameComponentsView.state = state
				}
			)
			.disposed(by: disposeBag)
	}
	
	// MARK: - Navigation Bar
	override var rightNavigationItemBundles: [NavigationItemBundle] {
		return viewModel.navigationBarProperties.rightNavigationItemBundles
	}
	
	override var shouldShowNavigationBar: Bool {
		return viewModel.navigationBarProperties.shouldShowNavigationBar
	}
	
	override var shouldShowLargeNavigationBar: Bool {
		return viewModel.navigationBarProperties.shouldShowLargeNavigationBar
	}
	
	override func navigationBarButtonTapped(_ button: NavigationBarButton) {
		switch button.bundle.type {
		case .cross:
			viewModel.inputs.crossButtonTapped()
		default:
			break
		}
	}
}

// MARK: - GameViewDelegate
extension GameViewController: GameViewDelegate {
	func gameView(_ view: GameView, didTrigger action: GameViewDelegateAction) {
		switch action {
		case .didReceiveTap(let index):
			viewModel.inputs.didSelectAnswer(at: index)
		}
	}
}

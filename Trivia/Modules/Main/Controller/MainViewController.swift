import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainViewController: BaseViewController {
	private let viewModel: MainViewModel
	
	private lazy var mainView: MainView = {
		let view = MainView()
		view.delegate = self
		return view
	}()
	
	// MARK: - Initializers
	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	init(viewModel: MainViewModel) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - View Lifecycle
	override func loadView() {
		super.loadView()
		
		view.addSubview(mainView)
		mainView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		bind(to: viewModel)
		viewModel.inputs.viewDidEndLoading()
	}
	
	// MARK: - ViewModel
	private func bind(to viewModel: MainViewModel) {
		viewModel.outputs.actions
			.subscribe(
				onNext: { [weak self] actions in
					self?.mainView.updateInterface(with: actions)
				}
			)
			.disposed(by: disposeBag)
	}
	
	// MARK: - Navigation Bar
	override var shouldShowNavigationBar: Bool {
		return viewModel.navigationBarProperties.shouldShowNavigationBar
	}
}

// MARK: - MainViewDelegate
extension MainViewController: MainViewDelegate {
	func mainView(_ view: MainView, didTrigger action: MainViewDelegateAction) {
		switch action {
		case .didReceiveTap(let index):
			viewModel.inputs.didReceiveTapForAction(at: index)
		}
	}
}

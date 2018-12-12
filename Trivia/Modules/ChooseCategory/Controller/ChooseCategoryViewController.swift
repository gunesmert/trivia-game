import UIKit
import RxSwift
import RxCocoa

final class ChooseCategoryViewController: BaseTableViewController {
	private let viewModel: ChooseCategoryViewModel
	
	private var categories: [Category] = [] {
		didSet {
			componentsView.tableView.reloadData()
		}
	}
	
	// MARK: - Initializers
	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	init(viewModel: ChooseCategoryViewModel) {
		self.viewModel = viewModel
		super.init()
		register(CategoryCell())
		componentsView.tableView.delegate = self
		componentsView.tableView.dataSource = self
		componentsView.tableView.estimatedRowHeight = UITableView.automaticDimension
		componentsView.tableView.reloadData()
		componentsView.tableView.separatorColor = ColorPalette.Primary.separator
		componentsView.emptyStateView.delegate = self
		componentsView.state = BaseComponentsViewState.idle
	}
	
	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		bind(to: viewModel)
		viewModel.inputs.viewDidEndLoading()
	}
	
	// MARK: - ViewModel
	private func bind(to viewModel: ChooseCategoryViewModel) {
		viewModel.outputs.navigationTitle
			.subscribe(
				onNext: { [weak self] title in
					self?.navigationItem.title = title
				}
			)
			.disposed(by: disposeBag)
		
		viewModel.outputs.categories
			.observeOn(MainScheduler.instance)
			.subscribe(
				onNext: { [weak self] categories in
					self?.categories = categories
				}
			)
			.disposed(by: disposeBag)
		
		viewModel.outputs.state
			.observeOn(MainScheduler.instance)
			.subscribe(
				onNext: { [weak self] state in
					self?.componentsView.state = state
				}
			)
			.disposed(by: disposeBag)
	}
	
	// MARK: - Navigation Bar
	override var leftNavigationItemBundles: [NavigationItemBundle] {
		return viewModel.navigationBarProperties.leftNavigationItemBundles
	}
	
	override var shouldShowNavigationBar: Bool {
		return viewModel.navigationBarProperties.shouldShowNavigationBar
	}
	
	override var shouldShowLargeNavigationBar: Bool {
		return viewModel.navigationBarProperties.shouldShowLargeNavigationBar
	}
	
	override func navigationBarButtonTapped(_ button: NavigationBarButton) {
		switch button.bundle.type {
		case .back:
			viewModel.inputs.backButtonTapped()
		default:
			break
		}
	}
	
	// MARK: - Cell Configuration
	private func configure(_ cell: CategoryCell, forRowAt indexPath: IndexPath) {
		guard indexPath.row < categories.count else { return }
		let category = categories[indexPath.row]
		cell.textLabel?.text = category.description
	}
}

// MARK: - UITableViewDataSource
extension ChooseCategoryViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier,
													   for: indexPath) as? CategoryCell else {
			return UITableViewCell()
		}
		configure(cell, forRowAt: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Constants.minimumDimension
	}
}

// MARK: - UITableViewDelegate
extension ChooseCategoryViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.inputs.didSelectCategory(at: indexPath.row)
	}
}

// MARK: - EmptyStateViewDelegate
extension ChooseCategoryViewController: EmptyStateViewDelegate {
	func emptyStateViewDidReceiveTap(_ view: EmptyStateView) {
		viewModel.inputs.emptyStateViewTapped()
	}
}

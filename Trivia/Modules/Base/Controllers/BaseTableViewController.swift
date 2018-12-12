import UIKit
import SnapKit

class BaseTableViewController: BaseViewController {
	let componentsView = BaseComponentsView()
	
	// MARK: - View Lifecycle
	override func loadView() {
		super.loadView()
		view.addSubview(componentsView)
		componentsView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
	
	// MARK: - Helper Methods
	func register<T: UITableViewCell>(_ cell: T) {
		componentsView.tableView.register(T.self, forCellReuseIdentifier: T.identifier)
	}
}

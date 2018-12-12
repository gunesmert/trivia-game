import UIKit
import SnapKit

enum BaseComponentsViewState {
	case idle
	case loading
	case error(String)
}

final class BaseComponentsView: UIView {
	lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = ColorPalette.Primary.Light.background
		tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
		tableView.separatorInset = UIEdgeInsets.zero
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		return tableView
	}()
	
	private lazy var activityIndicatorHolderView: UIView = {
		let view = UIView()
		view.backgroundColor = ColorPalette.Primary.Light.background
		view.isHidden = true
		return view
	}()
	
	private lazy var activityIndicatorView: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
		view.color = ColorPalette.Primary.tint
		view.hidesWhenStopped = true
		return view
	}()
	
	lazy var emptyStateView: EmptyStateView = {
		let view = EmptyStateView()
		view.backgroundColor = ColorPalette.Primary.Light.background
		view.isHidden = true
		return view
	}()
	
	var contentInset = UIEdgeInsets.zero {
		didSet {
			updateInterface()
		}
	}
	
	var state: BaseComponentsViewState = .idle {
		didSet {
			updateInterface(with: state)
		}
	}
	
	// MARK: - Initializers
	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(tableView)
		tableView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		addSubview(emptyStateView)
		emptyStateView.snp.makeConstraints { (make) in
			make.leading.top.trailing.equalToSuperview()
			make.bottom.equalToSuperview().inset(0.0)
		}
		
		addSubview(activityIndicatorHolderView)
		activityIndicatorHolderView.snp.makeConstraints { (make) in
			make.leading.top.trailing.equalToSuperview()
			make.bottom.equalToSuperview().inset(0.0)
		}
		
		activityIndicatorHolderView.addSubview(activityIndicatorView)
		activityIndicatorView.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
		}
	}
	
	// MARK: - Interface
	private func updateInterface() {
		tableView.contentInset = contentInset
		tableView.scrollIndicatorInsets = contentInset
		
		emptyStateView.snp.updateConstraints { (update) in
			update.bottom.equalToSuperview().inset(contentInset.bottom)
		}
		
		activityIndicatorHolderView.snp.updateConstraints { (update) in
			update.bottom.equalToSuperview().inset(contentInset.bottom)
		}
	}
	
	private func updateInterface(with state: BaseComponentsViewState) {
		switch state {
		case .idle:
			activityIndicatorHolderView.isHidden = true
			activityIndicatorView.stopAnimating()
			emptyStateView.isHidden = true
		case .loading:
			bringSubviewToFront(activityIndicatorHolderView)
			activityIndicatorHolderView.isHidden = false
			activityIndicatorView.startAnimating()
			emptyStateView.isHidden = true
		case .error(let message):
			bringSubviewToFront(emptyStateView)
			activityIndicatorHolderView.isHidden = true
			activityIndicatorView.stopAnimating()
			emptyStateView.mode = EmptyStateMode.custom(message)
			emptyStateView.isHidden = false
		}
	}
}

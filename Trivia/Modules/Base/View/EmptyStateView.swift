import UIKit
import SnapKit

enum EmptyStateMode {
	case noResults
	case noConnection
	case custom(String)
	
	var information: String {
		switch self {
		case .noResults:
			return NSLocalizedString("No results", comment: "")
		case .noConnection:
			return NSLocalizedString("No connection", comment: "")
		case .custom(let message):
			return message
		}
	}
}

extension EmptyStateMode: Equatable {
	static func ==(lhs: EmptyStateMode, rhs: EmptyStateMode) -> Bool {
		switch (lhs, rhs) {
		case (.noResults, .noResults), (.noConnection, .noConnection):
			return true
		case (.custom, .custom):
			return lhs.information == rhs.information
		default:
			return false
		}
	}
}

final class EmptyStateView: UIView {
	weak var delegate: EmptyStateViewDelegate?
	
	private lazy var informationLabel: InsetLabel = {
		let label = InsetLabel()
		label.insets = UIEdgeInsets(top: Constants.defaultMargin,
									left: Constants.defaultMargin,
									bottom: Constants.defaultMargin,
									right: Constants.defaultMargin)
		label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)
		label.textColor = ColorPalette.Primary.Light.text
		label.textAlignment = NSTextAlignment.center
		label.numberOfLines = 0
		
		return label
	}()
	
	private lazy var contentView: UIStackView = {
		let view = UIStackView()
		view.distribution = UIStackView.Distribution.fillProportionally
		view.axis = NSLayoutConstraint.Axis.vertical
		view.spacing = Constants.defaultMargin
		return view
	}()
	
	var mode = EmptyStateMode.noResults {
		didSet {
			updateInterface()
		}
	}
	
	// MARK: - Initializers
	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = ColorPalette.Primary.Light.background
		
		addSubview(contentView)
		contentView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(Constants.defaultMargin)
			make.centerY.equalToSuperview()
		}
		
		contentView.addArrangedSubview(informationLabel)
		
		let selector = #selector(didReceiveTap(_:))
		let recognizer = UITapGestureRecognizer(target: self, action: selector)
		addGestureRecognizer(recognizer)
	}
	
	// MARK: - Interface
	private func updateInterface() {
		informationLabel.text = mode.information
	}
	
	// MARK: - Gesture
	@objc private func didReceiveTap(_ sender: Any) {
		delegate?.emptyStateViewDidReceiveTap(self)
	}
}

// MARK: - EmptyStateViewDelegate
protocol EmptyStateViewDelegate: class {
	func emptyStateViewDidReceiveTap(_ view: EmptyStateView)
}

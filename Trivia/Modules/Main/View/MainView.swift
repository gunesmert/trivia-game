import UIKit
import SnapKit

final class MainView: UIView {
	weak var delegate: MainViewDelegate?
	
	private lazy var logoImageView: UIImageView = {
		let image = UIImage(named: "logo_large")
		let view = UIImageView(image: image)
		view.backgroundColor = ColorPalette.Primary.Light.background
		view.contentMode = UIView.ContentMode.center
		return view
	}()
	
	private lazy var actionsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.distribution = UIStackView.Distribution.fillEqually
		stackView.axis = NSLayoutConstraint.Axis.vertical
		stackView.spacing = Constants.defaultSpacing
		return stackView
	}()
	
	// MARK: - Initializers
	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = ColorPalette.Primary.Light.background
		
		addSubview(actionsStackView)
		actionsStackView.snp.makeConstraints { make in
			make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(Constants.defaultMargin * 2)
			make.leading.trailing.equalToSuperview().inset(Constants.defaultMargin * 2)
			make.height.equalTo(0.0)
		}
		
		addSubview(logoImageView)
		logoImageView.snp.makeConstraints { make in
			make.top.equalTo(safeAreaLayoutGuide.snp.top)
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(actionsStackView.snp.top)
		}
	}
	
	// MARK: - Methods
	func updateInterface(with actions: [MainViewAction]) {
		actionsStackView.arrangedSubviews.forEach({
			actionsStackView.removeArrangedSubview($0)
			$0.removeFromSuperview()
		})
		
		for action in actions {
			let button = PrimaryButton()
			button.setTitle(action.title, for: UIControl.State.normal)
			button.addTarget(self,
							 action: #selector(buttonTapped(_:)),
							 for: UIControl.Event.touchUpInside)
			
			actionsStackView.addArrangedSubview(button)
		}
		
		var height = CGFloat(actions.count) * Constants.minimumDimension
		height += CGFloat(actions.count) * actionsStackView.spacing
		
		actionsStackView.snp.updateConstraints { update in
			update.height.equalTo(height)
		}
	}
	
	// MARK: - Helper Methods
	private func index(of actionButton: PrimaryButton) -> Int? {
		guard let buttons = actionsStackView.arrangedSubviews as? [PrimaryButton] else { return nil }
		for (index, button) in buttons.enumerated() { if button === actionButton { return index } }
		return nil
	}
	
	// MARK: - Actions
	@objc func buttonTapped(_ actionButton: PrimaryButton) {
		guard let index = index(of: actionButton) else { return }
		let action = MainViewDelegateAction.didReceiveTap(index)
		delegate?.mainView(self, didTrigger: action)
	}
}

enum MainViewDelegateAction {
	case didReceiveTap(Int)
}

// MARK: - MainViewDelegate
protocol MainViewDelegate: class {
	func mainView(_ view: MainView, didTrigger action: MainViewDelegateAction)
}

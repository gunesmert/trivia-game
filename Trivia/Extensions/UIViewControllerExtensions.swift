import UIKit

extension UIViewController {
	func presentAlert(with viewModel: AlertControllerViewModel) {
		let controller = UIAlertController(title: viewModel.title,
										   message: viewModel.message,
										   preferredStyle: viewModel.style)
		
		viewModel.items.forEach({ actionItem in
			let action = UIAlertAction(
				title: actionItem.title,
				style: actionItem.style,
				handler: { _ in
					actionItem.actionHandler?()
			})
			
			controller.addAction(action)
		})
		
		if let title = viewModel.cancelActionTitle {
			controller.addAction(UIAlertAction(title: title, style: .cancel))
		}
		
		present(controller, animated: true, completion: nil)
	}
}

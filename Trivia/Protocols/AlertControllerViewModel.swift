import UIKit

struct AlertControllerViewModel {
	struct Action {
		let title: String
		let style: UIAlertAction.Style
		let actionHandler: (() -> Void)?
	}
	
	let style: UIAlertController.Style
	let title: String?
	let message: String?
	let items: [Action]
	let cancelActionTitle: String? = nil
}

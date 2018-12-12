import UIKit

protocol StaticallyIdentifiable {
	static var identifier: String { get }
}

extension StaticallyIdentifiable {
	static var identifier: String {
		return String(describing: self)
	}
}

extension UITableViewCell: StaticallyIdentifiable { }

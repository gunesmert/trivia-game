import UIKit

enum NavigationItemType {
	case back
	case cross
	case custom(String?)
	
	var bundle: NavigationItemBundle {
		return NavigationItemBundle(withType: self)
	}
}

final class NavigationItemBundle {
	var type: NavigationItemType
	
	init(withType type: NavigationItemType) {
		self.type = type
	}
	
	var width: CGFloat {
		guard let title = title else {
			return 44.0
		}
		var attributes: [NSAttributedString.Key: Any] = [:]
		attributes[NSAttributedString.Key.font] = NavigationBarButton.font
		return title.width(withAttributes: attributes) + 24.0
	}
	
	var title: String? {
		switch type {
		case .custom(let text):
			return text
		default:
			return nil
		}
	}
	
	var image: UIImage? {
		let mode = UIImage.RenderingMode.alwaysTemplate
		
		switch type {
		case .back:
			return UIImage(named: "icon-left_arrow")?.withRenderingMode(mode)
		case .cross:
			return UIImage(named: "icon-cross")?.withRenderingMode(mode)
		default:
			return nil
		}
	}
}

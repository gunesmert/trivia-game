import UIKit

extension String {
	func width(withAttributes attributes: [NSAttributedString.Key: Any]) -> CGFloat {
		let size = CGSize(width: CGFloat.greatestFiniteMagnitude,
						  height: CGFloat.greatestFiniteMagnitude)
		
		return self.boundingRect(with: size,
								 options: NSStringDrawingOptions.usesLineFragmentOrigin,
								 attributes: attributes,
								 context: nil).width
	}
}

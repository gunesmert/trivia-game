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
	
	var htmlDecoded: String {
		let decoded = try? NSAttributedString(data: Data(utf8), options: [
			.documentType: NSAttributedString.DocumentType.html,
			.characterEncoding: String.Encoding.utf8.rawValue
			], documentAttributes: nil).string
		
		return decoded ?? self
	}
}

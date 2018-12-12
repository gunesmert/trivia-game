import UIKit

public struct ColorPalette {
	public struct Primary {
		public static let buttonBackground = UIColor.black
		
		public struct Light {
			public static let text = UIColor.white
			public static let background = UIColor.turkishRose
		}
		
		public struct Dark {
			public static let text = UIColor.black
		}
	}
	
//	public struct Secondary {
//
//	}
}

// MARK: - Private Colors
extension UIColor {
	convenience init(hexString: String) {
		let hex = hexString.replacingOccurrences(of: "#", with: "")
		guard hex.count == 6, let hexValue = Int(hex, radix: 16) else {
			self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
			return
		}
		self.init(red:   CGFloat( (hexValue & 0xFF0000) >> 16 ) / 255.0,
				  green: CGFloat( (hexValue & 0x00FF00) >> 8 ) / 255.0,
				  blue:  CGFloat( (hexValue & 0x0000FF) >> 0 ) / 255.0,
				  alpha: 1.0)
	}
}

private extension UIColor {
	/*
	For color naming conventions, an app called `Sip` was used.
	Link: https://sipapp.io
	*/
	
	static var mandysPink: UIColor {
		return UIColor(hexString: "#F8B195")
	}
	
	static var froly: UIColor {
		return UIColor(hexString: "#F67280")
	}
	
	static var turkishRose: UIColor {
		return UIColor(hexString: "#C06C84")
	}
	
	static var dolphin: UIColor {
		return UIColor(hexString: "#6C5B7B")
	}
	
	static var matisse: UIColor {
		return UIColor(hexString: "#355C7D")
	}
}

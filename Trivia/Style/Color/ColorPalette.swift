import UIKit

public struct ColorPalette {
	public struct Primary {
		public static let tint = UIColor.dolphin
		public static let navigationBarButtonTint = UIColor.mandysPink
		public static let buttonBackground = UIColor.dolphin
		public static let separator = UIColor.mandysPink
		
		public struct Light {
			public static let text = UIColor.white
			public static let background = UIColor.turkishRose
		}
		
		public struct Dark {
			public static let text = UIColor.black
		}
	}
	
	public struct Answer {
		public static let `default` = UIColor.dolphin
		public static let selected = UIColor.matisse
		public static let correct = UIColor.lightForestGreen
		public static let incorrect = UIColor.alizarinCrimson
	}
	
	public struct GameAction {
		public static let displayAnswer = UIColor.mandysPink
		public static let nextQuestion = UIColor.matisse
		public static let correctAnswer = UIColor.lightForestGreen
		public static let incorrectAnswer = UIColor.alizarinCrimson
		public static let gameFinished = UIColor.mandysPink
	}
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
	
	static var lightForestGreen: UIColor {
		return UIColor(hexString: "#65A380")
	}
	
	static var alizarinCrimson: UIColor {
		return UIColor(hexString: "#DB2B30")
	}
}

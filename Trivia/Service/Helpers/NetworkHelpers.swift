import Foundation

enum HttpMethod: String {
	case get
	case post
	case put
	case delete
	case patch
	case head
	
	var value: String {
		return self.rawValue.uppercased()
	}
}

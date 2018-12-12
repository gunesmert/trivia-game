import Foundation

enum NetworkClientErrorType {
	case invalidURL(String)
	case invalidResponse(URLResponse?, Data?)
	case noInternetConnection
	case unauthorized
	case errorMessage(String)
	case unknownError
	
	var localizedDescription: String {
		switch self {
		case .errorMessage(let message):
			return message
		default:
			return NSLocalizedString("An unknown error occurred. Please try again.", comment: "")
		}
	}
}

final class NetworkClientError: NSObject, LocalizedError {
	let type: NetworkClientErrorType
	
	init(type: NetworkClientErrorType) {
		self.type = type
	}
	
	override var description: String {
		return type.localizedDescription
	}
	
	var errorDescription: String? {
		return description
	}
}

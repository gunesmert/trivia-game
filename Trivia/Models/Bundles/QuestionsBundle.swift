import Foundation

enum ResponseCode: Int, Codable {
	case success 			= 0
	case noResults			= 1
	case invalidParameter	= 2
	case tokenNotFound		= 3
	case tokenEmpty			= 4
	
	var localizedDescription: String {
		switch self {
		case .success:
			return ""
		case .noResults:
			return NSLocalizedString("Unfortunately, we don't enough content to show you at the moment. Please try a different category.", comment: "")
		case .invalidParameter, .tokenNotFound, .tokenEmpty:
			return NSLocalizedString("There is a problem happened. Please try again later.", comment: "")
		}
	}
}

struct QuestionsBundle {
	var responseCode: ResponseCode
	var questions: [Question]
}

private enum CodingKeys: String, CodingKey {
	case questions = "results"
	case responseCode = "response_code"
}

// MARK: - Decodable
extension QuestionsBundle: Decodable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		questions = try container.decode([Question].self, forKey: .questions)
		responseCode = try container.decode(ResponseCode.self, forKey: .responseCode)
	}
}

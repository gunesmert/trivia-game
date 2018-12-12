import Foundation

enum ResponseCode: Int, Codable {
	case success 			= 0
	case noResults			= 1
	case invalidParameter	= 2
	case tokenNotFound		= 3
	case tokenEmpty			= 4
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

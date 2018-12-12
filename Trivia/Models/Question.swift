import Foundation
import GameKit

enum QuestionDifficulty: String, Codable {
	case easy
	case medium
	case hard
}

enum QuestionType: String, Codable {
	case boolean
	case multiple
}

struct Question {
	var categoryDescription: String
	var correctAnswer: String
	var incorrectAnswers: [String]
	var difficulty: QuestionDifficulty
	var type: QuestionType
	var questionSentence: String
	
	func shuffledAnswers() -> [String] {
		return (incorrectAnswers + [correctAnswer]).shuffled()
	}
}

private enum CodingKeys: String, CodingKey {
	case categoryDescription 	= "category"
	case correctAnswer 			= "correct_answer"
	case incorrectAnswers 		= "incorrect_answers"
	case difficulty 			= "difficulty"
	case type 					= "type"
	case questionSentence		= "question"
}

// MARK: - Decodable
extension Question: Decodable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		categoryDescription = try container.decode(String.self, forKey: .categoryDescription).htmlDecoded
		correctAnswer = try container.decode(String.self, forKey: .correctAnswer).htmlDecoded
		incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers).compactMap({ $0.htmlDecoded })
		difficulty = try container.decode(QuestionDifficulty.self, forKey: .difficulty)
		type = try container.decode(QuestionType.self, forKey: .type)
		questionSentence = try container.decode(String.self, forKey: .questionSentence).htmlDecoded
	}
}

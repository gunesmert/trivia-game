import Foundation

struct Category {
	var identifier: Int
	var description: String
}

private enum CodingKeys: String, CodingKey {
	case identifier = "id"
	case description = "name"
}

// MARK: - Decodable
extension Category: Decodable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		identifier = try container.decode(Int.self, forKey: .identifier)
		description = try container.decode(String.self, forKey: .description)
	}
}

// MARK: - Encodable
extension Category: Encodable {
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(identifier, forKey: .identifier)
		try container.encode(description, forKey: .description)
	}
}

import Foundation

struct CategoriesBundle {
	var categories: [Category]
}

private enum CodingKeys: String, CodingKey {
	case categories = "trivia_categories"
}

// MARK: - Decodable
extension CategoriesBundle: Decodable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		categories = try container.decode([Category].self, forKey: .categories)
	}
}

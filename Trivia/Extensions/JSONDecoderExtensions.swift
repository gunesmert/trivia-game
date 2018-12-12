import Foundation

extension JSONDecoder {
	static var ikea: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		return decoder
	}
}

import Foundation
import RxSwift

protocol APIClient {
	func fetchCategories() -> Single<Data>
	func fetchQuestions(with parameters: Parameters) -> Single<Data>
}

enum Path: String {
	case categories	= "/api_category.php"
	case questions	= "/api.php"
}

struct DefaultAPIClient: APIClient {
	private let networkClient: NetworkClient
	
	init(networkClient: NetworkClient) {
		self.networkClient = networkClient
	}
	
	func fetchCategories() -> Single<Data> {
		let endpoint = DefaultAPIEndpoint(path: Path.categories.rawValue,
										  httpMethod: HttpMethod.get)
		return networkClient.fetch(endpoint)
	}
	
	func fetchQuestions(with parameters: Parameters) -> Single<Data> {
		let endpoint = DefaultAPIEndpoint(path: Path.questions.rawValue,
										  httpMethod: HttpMethod.get,
										  parameters: parameters)
		return networkClient.fetch(endpoint)
	}
}

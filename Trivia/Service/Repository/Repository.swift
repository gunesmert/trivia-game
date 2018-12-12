import Foundation
import RxSwift

protocol Repository {
	func fetchCategories() -> Single<CategoriesBundle>
}

final class DefaultRepository: Repository {
	let client: APIClient
	
	init(with client: APIClient) {
		self.client = client
	}
	
	func fetchCategories() -> Single<CategoriesBundle> {
		return client.fetchCategories().map {
			return try JSONDecoder.ikea.decode(CategoriesBundle.self, from: $0)
		}
	}
}

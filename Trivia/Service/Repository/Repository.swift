import Foundation
import RxSwift

protocol Repository {
	func fetchCategories() -> Single<CategoriesBundle>
	func fetchQuestions(with category: Category?) -> Single<QuestionsBundle>
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
	
	func fetchQuestions(with category: Category?) -> Single<QuestionsBundle> {
		var queryParameters = [String: Any]()
		queryParameters["category"] = category?.identifier
		queryParameters["amount"] = Constants.defaultQuestionCountOfAGame
		
		let parameters = Parameters.query(queryParameters)
		return client.fetchQuestions(with: parameters).map {
			return try JSONDecoder.ikea.decode(QuestionsBundle.self, from: $0)
		}
	}
}

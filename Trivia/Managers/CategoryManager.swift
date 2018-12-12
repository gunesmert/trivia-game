import Foundation

protocol CategoryManager {
	var latestUsedCategory: Category? { get }
	func updateLatestUsedCategory(_ category: Category)
}

final class DefaultCategoryManager: CategoryManager {
	private(set) var latestUsedCategory: Category?
	
	// MARK: - Initializers
	init() {
		let defaults = UserDefaults.standard
		
		guard let json = defaults.string(forKey: Constants.Keys.lastUsedCategory) else { return }
		guard let data = json.data(using: String.Encoding.utf8) else { return }
		
		do {
			latestUsedCategory = try JSONDecoder().decode(Category.self, from: data)
		} catch {
			
		}
	}
	
	// MARK: - Methods
	func updateLatestUsedCategory(_ category: Category) {
		latestUsedCategory = category
		do {
			let data = try JSONEncoder().encode(category)
			let json = String(data: data, encoding: String.Encoding.utf8)
			let defaults = UserDefaults.standard
			defaults.set(json, forKey: Constants.Keys.lastUsedCategory)
		} catch {
			
		}
	}
}

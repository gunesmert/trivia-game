import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
	var window: UIWindow?
	private let rootCoordinator: RootCoordinator
	
	override init() {
		let urlString = "https://opentdb.com" // ESB
		let networkClient = DefaultNetworkClient(with: urlString)
		let apiClient = DefaultAPIClient(networkClient: networkClient)
		let repository = DefaultRepository(with: apiClient)
		
		self.rootCoordinator = RootCoordinator(with: repository)
		
		super.init()
	}
}

// MARK: - UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = rootCoordinator.viewController
		window.makeKeyAndVisible()
		
		self.window = window
		
		return true
	}
}

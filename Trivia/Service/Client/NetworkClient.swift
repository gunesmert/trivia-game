import Foundation
import RxSwift

protocol NetworkClient {
	var fetch: (APIEndpoint) -> Single<Data> { get }
}

struct DefaultNetworkClient: NetworkClient {
	let fetch: (APIEndpoint) -> Single<Data>
	
	init(with urlString: String) {
		self.fetch = { (endpoint) -> Single<Data> in
			return NetworkClientCommons
				.createRequest(with: urlString, andEndpoint: endpoint)
				.flatMap(NetworkClientCommons.performRequest)
				.flatMap(NetworkClientCommons.validateResponse)
		}
	}
}

// MARK: - NetworkClientCommons
enum NetworkClientCommons {
	static func createRequest(with urlString: String,
							  andEndpoint endpoint: APIEndpoint) -> Single<URLRequest> {
		return Single<URLRequest>.create { single in
			let adapter = DefaultAPIAdapter(with: urlString, andEndpoint: endpoint)
			guard let request = adapter.request else {
				single(.error(NetworkClientError(type: .invalidURL(endpoint.path))))
				return Disposables.create()
			}
			
			single(.success(request))
			return Disposables.create()
		}
	}
	
	static func validateResponse(_ responseAndData: (response: HTTPURLResponse,
		data: Data)) -> Single<Data> {
		let (response, data) = responseAndData
		
		guard 200..<400 ~= response.statusCode else {
			if response.statusCode == 401 {
				return .error(NetworkClientError(type: .unauthorized))
			}
			
			return .error(NetworkClientError(type: .invalidResponse(response, data)))
		}
		
		return .just(data)
	}
	
	static func performRequest(with request: URLRequest) -> Single<(response: HTTPURLResponse, data: Data)> {
		return Single<(response: HTTPURLResponse, data: Data)>.create { single in
			let task = URLSession.shared.dataTask(with: request) { (data: Data?,
				response: URLResponse?,
				error: Error?) in
				if let error = error {
					let errorCode = (error as NSError).code
					
					if errorCode == -1009 {
						single(.error(NetworkClientError(type: .noInternetConnection)))
					} else {
						single(.error(error))
					}
					
					return
				}
				
				guard let HTTPResponse = response as? HTTPURLResponse else {
					single(.error(NetworkClientError(type: .invalidResponse(response, data))))
					return
				}
				
				single(SingleEvent<(response: HTTPURLResponse, data: Data)>.success((response: HTTPResponse,
																					 data: data ?? Data())))
			}
			task.resume()
			
			return Disposables.create { task.cancel() }
		}
	}
}

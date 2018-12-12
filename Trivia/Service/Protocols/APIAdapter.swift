import Foundation
import UIKit

protocol APIAdapter {
	var request: URLRequest? { get }
	var endpoint: APIEndpoint { get }
	var host: String { get }
	var defaultHeaderParameters: [HeaderParameter] { get }
	
	init(with host: String, andEndpoint endpoint: APIEndpoint)
}

extension APIAdapter {
	var request: URLRequest? {
		guard var components = URLComponents(string: host) else { return nil }
		components.path = endpoint.path
		
		if let parameters = endpoint.parameters {
			switch parameters {
			case .query(let items):
				components.queryItems = items.map {
					URLQueryItem(name: $0.key, value: "\($0.value)")
				}
				let query = components.query
				var characters = CharacterSet.urlQueryAllowed
				characters.remove("+")
				let encodedQuery = query?.addingPercentEncoding(withAllowedCharacters: characters)
				components.percentEncodedQuery = encodedQuery
			default:
				break
			}
		}
		
		guard let url = components.url else { return nil }
		var request = URLRequest(url: url)
		request.httpMethod = endpoint.httpMethod.value
		
		let headerParameters = defaultHeaderParameters + (endpoint.headerParameters ?? [])
		let allHTTPHeaderFields = Dictionary(uniqueKeysWithValues: headerParameters.map{ ($0.key, $0.value) })
		request.allHTTPHeaderFields = allHTTPHeaderFields
		
		if let parameters = endpoint.parameters {
			switch parameters {
			case .form(let items):
				var formComponents = URLComponents()
				formComponents.queryItems = items.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
				request.httpBody = formComponents.query?.data(using: String.Encoding.utf8, allowLossyConversion: false)
			case .body(let payload):
				do {
					let some = try JSONSerialization.data(withJSONObject: payload,
														  options: [])
					print(String(data: some, encoding: .utf8)!)
					request.httpBody = try JSONSerialization.data(withJSONObject: payload,
																  options: [])
				} catch {
					
				}
			case .data(let data):
				request.httpBody = data
			default:
				break
			}
		}
		
		return request
	}
	
	var defaultHeaderParameters: [HeaderParameter] {
		var fields = [HeaderParameter]()
		
		if let parameters = endpoint.parameters {
			switch parameters {
			case .body, .data:
				fields.append(HeaderParameter.contentType("application/json"))
			case .form:
				fields.append(HeaderParameter.contentType("application/x-www-form-urlencoded"))
			default:
				break
			}
		}
		
		return fields
	}
}

struct DefaultAPIAdapter: APIAdapter {
	var endpoint: APIEndpoint
	var host: String
	
	init(with host: String, andEndpoint endpoint: APIEndpoint) {
		self.endpoint = endpoint
		self.host = host
	}
}

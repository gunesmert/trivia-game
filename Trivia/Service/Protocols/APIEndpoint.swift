import Foundation

enum Parameters {
	case query([String: Any])
	case form([String: Any])
	case body(Any)
	case data(Data)
}

enum HeaderParameter {
	case contentType(String)
	case authorization(String)
	case acceptLanguage(String)
	
	var key: String {
		switch self {
		case .contentType:
			return "Content-Type"
		case .authorization:
			return "Authorization"
		case .acceptLanguage:
			return "Accept-Language"
		}
	}
	
	var value: String {
		switch self {
		case .contentType(let value):
			return value
		case .authorization(let value):
			return value
		case .acceptLanguage(let value):
			return value
		}
	}
}

protocol APIEndpoint {
	var path: String { get }
	var httpMethod: HttpMethod { get }
	var parameters: Parameters? { get }
	var headerParameters: [HeaderParameter]? { get }
	
	init(path: String,
		 httpMethod: HttpMethod,
		 parameters: Parameters?,
		 headerParameters: [HeaderParameter]?)
}

struct DefaultAPIEndpoint: APIEndpoint {
	let path: String
	let httpMethod: HttpMethod
	let parameters: Parameters?
	var headerParameters: [HeaderParameter]?
	
	init(path: String,
		 httpMethod: HttpMethod,
		 parameters: Parameters? = nil,
		 headerParameters: [HeaderParameter]? = nil) {
		self.path = path
		self.httpMethod = httpMethod
		self.parameters = parameters
		self.headerParameters = headerParameters
	}
}

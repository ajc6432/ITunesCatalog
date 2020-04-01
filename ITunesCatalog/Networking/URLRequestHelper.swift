import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

protocol URLRequestHelperProtocol {
    func createGetRequest(withBasePath path: String, pathParams: [String: String]?) -> URLRequest?
}

class URLRequestHelper: URLRequestHelperProtocol {
    func createGetRequest(withBasePath path: String, pathParams: [String: String]?) -> URLRequest? {

        if let pathParams = pathParams, !pathParams.isEmpty {
            var components = URLComponents(string: path)
            var queryItems = [URLQueryItem]()
            pathParams.forEach({ key, val in
                queryItems.append(URLQueryItem(name: key, value: val))
            })
            components?.queryItems = queryItems
            guard let url = components?.url else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get.rawValue
            return request
        }

        guard let url = URL(string: path) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }
}

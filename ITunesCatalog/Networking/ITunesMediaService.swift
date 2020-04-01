import Foundation

enum ITunesMediaServiceError: Error {
    case couldNotCreateRequest
    case decodingError
    case encodingError
    case networkingError
}

protocol ITunesMediaServiceProtocol {
    func searchITunes(withQuery query: String, completion: @escaping (JSONResult) -> Void)
}

class ITunesMediaService: ITunesMediaServiceProtocol {
    private let searchBaseURL = "https://itunes.apple.com/search"

    let networkManager: NetworkManagerProtocol
    let urlRequestHelper: URLRequestHelperProtocol

    init(networkManager: NetworkManagerProtocol, urlRequestHelper: URLRequestHelperProtocol) {
        self.networkManager = networkManager
        self.urlRequestHelper = urlRequestHelper
    }

    func searchITunes(withQuery query: String, completion: @escaping (JSONResult) -> Void) {
        guard let request = urlRequestHelper.createGetRequest(withBasePath: searchBaseURL, pathParams: ["term": query]) else {
            completion(.failure(ITunesMediaServiceError.couldNotCreateRequest))
            return
        }

        networkManager.performGetRequest(withURLRequest: request) { dataResult in
            switch dataResult {
            case .success(let data):
                do {
                    let searchResult = try JSONDecoder().decode(ITunesMediaSearchResult.self, from: data)
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    let itunesMediaCatalogData = try encoder.encode(searchResult)
                    completion(JSONResult.success(itunesMediaCatalogData))
                } catch {
                    completion(.failure(ITunesMediaServiceError.decodingError))
                }
            case .failure:
                completion(.failure(ITunesMediaServiceError.networkingError))
            }
        }
    }

    private func encodeToJSONData(_ val: [ITunesMedia]) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(val)
        return data
    }
}

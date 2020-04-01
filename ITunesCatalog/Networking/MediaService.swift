import Foundation

enum MediaServiceError: Error {
    case decodingError
    case itunesMediaServiceError
}

protocol MediaServiceProtocol {
    func fetchMedia(withQuery query: String, completion: @escaping (MediaCatalogResult) -> Void)
}

class MediaService: MediaServiceProtocol {

    let iTunesMediaService: ITunesMediaServiceProtocol

    static let shared = MediaService(itunesMediaService: ITunesMediaService(networkManager: NetworkManager(), urlRequestHelper: URLRequestHelper()))

    init(itunesMediaService: ITunesMediaServiceProtocol) {
        self.iTunesMediaService = itunesMediaService
    }

    func fetchMedia(withQuery query: String, completion: @escaping (MediaCatalogResult) -> Void) {
        iTunesMediaService.searchITunes(withQuery: query) { dataResult in
            switch dataResult {
            case .success(let data):
                do {
                    let catalog = try JSONDecoder().decode(MediaCatalog.self, from: data)
                    completion(.success(catalog))
                } catch {
                    completion(.failure(MediaServiceError.decodingError))
                }
            case .failure(let iTunesMediaServiceError):
                //log error returned from itunes media service directly here
                completion(.failure(MediaServiceError.itunesMediaServiceError))
            }
        }
    }
}

import Foundation

protocol MediaCatalogViewModelProtocol {
    func performFetch(query: String)
    var mediaFetchingDelegate: MediaFetchingDelegate? { get set }
}

class MediaCatalogViewModel: MediaCatalogViewModelProtocol {
    weak var mediaFetchingDelegate: MediaFetchingDelegate?

    var mediaService: MediaServiceProtocol! = MediaService.shared
    var alertHelper: AlertHelperProtocol! = AlertHelper.shared

        func performFetch(query: String) {
        mediaService.fetchMedia(withQuery: query) { [weak self] catalogResult in
            DispatchQueue.main.async {
                switch catalogResult {
                case .success(let catalog):
                    let mediaDeictionary = catalog.media.filter { !$0.value.isEmpty }
                    self?.mediaFetchingDelegate?.populateMedia(with: mediaDeictionary)
                case .failure:
                    self?.mediaFetchingDelegate?.displayLoadingError()
                }
            }
        }
    }
}

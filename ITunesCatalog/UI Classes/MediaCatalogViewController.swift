import UIKit

protocol MediaFetchingDelegate: class {
    func populateMedia(with mediaDictionary: [MediaType: [Media]])
    func displayLoadingError()
}

class MediaCatalogViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Dependencies
    var viewModel: MediaCatalogViewModelProtocol? = MediaCatalogViewModel()

    // MARK: - Properties
    var allMedia: [MediaType: [Media]] = [:] {
        didSet {
            self.tableView.reloadData()
        }
    }

    var mediaKeys: [MediaType] {
        return allMedia.keys.sorted(by: { $1.rawValue < $0.rawValue })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        searchBar.delegate = self

        viewModel?.mediaFetchingDelegate = self
    }

    var mediaService: MediaServiceProtocol! = MediaService.shared
    var alertHelper: AlertHelperProtocol! = AlertHelper.shared

    // MARK: - Private Methods
    private func keyFor(section: Int) -> MediaType? {
        guard section < mediaKeys.count else { return nil }
        return mediaKeys[section]
    }
}

extension MediaCatalogViewController: MediaFetchingDelegate {
    func populateMedia(with mediaDictionary: [MediaType: [Media]]) {
        allMedia = mediaDictionary.filter { !$0.value.isEmpty }
    }

    func displayLoadingError() {
        alertHelper.showOKAlert(onViewController: self, withTitle: "Error", withMessage: "Sorry, there was an error searching. Try again later.", completionHandler: nil)
    }
}

extension MediaCatalogViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.performFetch(query: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
}

extension MediaCatalogViewController: UITableViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mediaKeys.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionKey = self.keyFor(section: indexPath.section),
              let sectionMedia = allMedia[sectionKey], indexPath.row < sectionMedia.count else { return }
        let media = sectionMedia[indexPath.row]
        media.toggleFavorite()
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let title = keyFor(section: section)?.rawValue else { return nil }
        return "\(title.capitalized)s"
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
}

// MARK: - UITableViewDataSource
extension MediaCatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let key = self.keyFor(section: section), let count = allMedia[key]?.count else { return 0}
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionKey = self.keyFor(section: indexPath.section),
              let sectionMedia = allMedia[sectionKey], indexPath.row < sectionMedia.count else { return UITableViewCell() }
        let media = sectionMedia[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaTableViewCell.identifier, for: indexPath) as? MediaTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(withMedia: media)
        return cell
    }
}

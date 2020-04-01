import UIKit

class MediaTableViewCell: UITableViewCell {
    static let identifier = "MediaTableViewCell"

    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!

    func configure(withMedia media: Media) {

        if let imageURL = URL(string: media.artwork),
            let imgData = try? Data(contentsOf: imageURL),
            let loadedImage = UIImage(data: imgData) {
            artworkImageView.image = loadedImage
        }

        nameLabel.text = "Name:\n\(media.name)"
        genreLabel.text = "Genre:\n\(media.genre)"
        linkLabel.text = "\(media.url)"
        favoriteImageView.isHidden = !media.isFavorite
    }
}

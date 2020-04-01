import Foundation

struct MediaCatalog: Decodable {
    var media: [MediaType: [Media]] = [:]
    private enum DecodingKeys: String, CodingKey {
        case books
        case albums
        case coachedAudios
        case featureMovies
        case interactiveBooklets
        case musicVideos
        case pdfPodcasts
        case podcastEpisodes
        case softwarePackages
        case songs
        case tvEpisodes
        case artists
        case unknowns
    }

    init() {
        media = [:]
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        for mediaType in MediaType.allCases {
            if let decodingKey = DecodingKeys(rawValue: "\(mediaType.rawValue)s") {
                media[mediaType] = try container.decode([Media].self, forKey: decodingKey)
            }
        }
    }
}

import Foundation

struct ITunesMediaSearchResult: Codable {
    let itunesMedia: [ITunesMedia]
    private var mediaDictionary: [MediaType: [ITunesMedia]] = [:]

    private enum DecodingKeys: String, CodingKey {
        case resultsNest = "results"
    }

    private enum EncodingKeys: String, CodingKey, CaseIterable {
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        itunesMedia = try container.decode([ITunesMedia].self, forKey: .resultsNest)

        for mediaType in MediaType.allCases {
            mediaDictionary[mediaType] = itunesMedia.filter { $0.kind == mediaType.rawValue }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        guard MediaType.allCases.count == EncodingKeys.allCases.count else { return }
        let sortedMediaTypes = MediaType.allCases.sorted(by: { $1.rawValue < $0.rawValue })
        let sortedEncodingKeys = EncodingKeys.allCases.sorted(by: { $1.rawValue < $0.rawValue })

        for i in 0..<EncodingKeys.allCases.count {
            try container.encode(mediaDictionary[sortedMediaTypes[i]], forKey: sortedEncodingKeys[i])

        }
    }
}

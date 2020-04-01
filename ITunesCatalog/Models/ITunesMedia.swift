import Foundation

struct ITunesMedia: Equatable, Hashable, Codable {
    let trackId: Int?
    let trackName: String
    let trackViewUrl: String
    let primaryGenreName: String
    let artworkUrl100: String
    let kind: String

    private enum EncodingKeys: String, CodingKey {
        case trackId = "id"
        case trackName = "name"
        case trackViewUrl = "url"
        case primaryGenreName = "genre"
        case artworkUrl100 = "artwork"
        case kind
    }

    private enum DecodingKeys: String, CodingKey {
        case trackId
        case trackName
        case trackViewUrl
        case primaryGenreName
        case artworkUrl100
        case kind
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(trackId, forKey: .trackId)
        try container.encode(trackName, forKey: .trackName)
        try container.encode(trackViewUrl, forKey: .trackViewUrl)
        try container.encode(primaryGenreName, forKey: .primaryGenreName)
        try container.encode(artworkUrl100, forKey: .artworkUrl100)
        try container.encode(kind, forKey: .kind)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        trackId = try? container.decode(Int.self, forKey: .trackId)
        trackName = (try? container.decode(String.self, forKey: .trackName)) ?? ""
        trackViewUrl = (try? container.decode(String.self, forKey: .trackViewUrl)) ?? ""
        primaryGenreName = (try? container.decode(String.self, forKey: .primaryGenreName)) ?? ""
        artworkUrl100 = (try? container.decode(String.self, forKey: .artworkUrl100)) ?? ""
        kind = (try? container.decode(String.self, forKey: .kind)) ?? ""
    }
}

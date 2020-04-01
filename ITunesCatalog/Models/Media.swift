import Foundation

class Media: Decodable {
    let id: Int?
    let name: String
    let artwork: String
    let genre: String
    let url: String
    let kind: String

    var isFavorite: Bool
    var mediaType: MediaType {
        return MediaType(rawValue: kind) ?? .unknown
    }

    private enum DecodingKeys: String, CodingKey {
        case id
        case name
        case artwork
        case genre
        case url
        case kind
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        id = try? container.decode(Int.self, forKey: .id)
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        url = (try? container.decode(String.self, forKey: .url)) ?? ""
        genre = (try? container.decode(String.self, forKey: .genre)) ?? ""
        artwork = (try? container.decode(String.self, forKey: .artwork)) ?? ""
        kind = (try? container.decode(String.self, forKey: .kind)) ?? ""
        isFavorite = false
    }

    func toggleFavorite() {
        self.isFavorite = !isFavorite
    }
}

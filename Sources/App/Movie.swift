import Hummingbird

public struct Movie: Sendable {
    public let id: Int
    public let name: String
    public let year: String
}

extension Movie: ResponseEncodable, Encodable, Decodable {}

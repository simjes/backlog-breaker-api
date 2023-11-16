import Vapor

struct GameResponse: Content {
    let name: String
    let igdbId: UInt64
    let imageUrl: String
}

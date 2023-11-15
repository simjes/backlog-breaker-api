import Fluent
import Vapor

final class Game: Model, Content {
    static let schema = "games"

    @ID(custom: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "igdbId")
    var igdbId: UInt64

    init() {}

    init(id: UUID? = nil, name: String, igdbId: UInt64) {
        self.id = id
        self.name = name
        self.igdbId = igdbId
    }
}

import Fluent

struct CreateGame: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("games")
            .id()
            .field("name", .string, .required)
            .field("igdbId", .uint64)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("games").delete()
    }
}

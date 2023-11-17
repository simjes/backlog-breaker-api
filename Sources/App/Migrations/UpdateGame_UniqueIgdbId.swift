import Fluent

struct UpdateGame_UniqueIgdbId: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("games")
            .unique(on: "igdbId")
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema("games")
            .deleteUnique(on: "igdbId")
            .update()
    }
}

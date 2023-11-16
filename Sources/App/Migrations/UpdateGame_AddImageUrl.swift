import Fluent

struct UpdateGame_AddImageUrl: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("games")
            .field("imageUrl", .string, .required, .sql(.default("")))
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema("games")
            .deleteField("imageUrl")
            .update()
    }
}

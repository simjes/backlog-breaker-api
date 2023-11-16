import Fluent

struct UpdateGame_AddImageId: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("games")
            .field("imageId", .string, .required, .sql(.default("")))
            .deleteField("imageUrl")
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema("games")
            .field("imageUrl", .string, .required, .sql(.default("")))
            .deleteField("imageId")
            .update()
    }
}

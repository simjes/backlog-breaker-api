import Fluent
import SQLKit

struct UpdateGame_IndexIgdbId: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await (database as! SQLDatabase)
            .create(index: "gameIgdb_index")
            .on("games")
            .column("igdbId")
            .run()
    }

    func revert(on database: Database) async throws {
        try await (database as! SQLDatabase)
            .drop(index: "gameIgdb_index")
            .on("games")
            .run()
    }
}

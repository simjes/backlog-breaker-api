import Fluent
import IGDB
import Vapor

struct GamesRoutes: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let games = routes.grouped("games")

        games.group(":gameId") { games in
            games.get(use: getGameById)
        }
    }

    func getGameById(req: Request) async throws -> GameResponse {
        guard let gameId = UInt64(req.parameters.get("gameId") ?? "") else {
            throw Abort(.notFound)
        }

        let game = try await Game.query(on: req.db).filter(\.$igdbId == gameId).first()

        if let existingGame = game {
            return GameResponse(name: existingGame.name, igdbId: existingGame.igdbId, imageUrl: existingGame.imageUrl)
        }

        guard let igdbGame = try await getGame(req: req, igdbId: gameId) else {
            throw Abort(.notFound)
        }

        let newGame = Game(name: igdbGame.name, igdbId: igdbGame.id, imageUrl: igdbGame.cover.url)
        try await newGame.save(on: req.db)

        return GameResponse(name: newGame.name, igdbId: newGame.igdbId, imageUrl: newGame.imageUrl)
    }
}

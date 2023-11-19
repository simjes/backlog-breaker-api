import Fluent
import IGDBClient
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
            let imageUrl = getImageUrl(existingGame.imageId)
            return GameResponse(name: existingGame.name, igdbId: existingGame.igdbId, imageUrl: imageUrl)
        }

        guard let igdbGame = try await getGame(req: req, igdbId: gameId) else {
            throw Abort(.notFound)
        }

        let newGame = Game(name: igdbGame.name, igdbId: igdbGame.id, imageId: igdbGame.cover.imageID)
        try await newGame.save(on: req.db)

        let imageUrl = getImageUrl(newGame.imageId)
        return GameResponse(name: newGame.name, igdbId: newGame.igdbId, imageUrl: imageUrl)
    }
}

import IGDB
import Vapor

struct GamesRoutes: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let games = routes.grouped("games")

        games.group(":gameId") { games in
            games.get(use: getGameById)
        }
    }

    func getGameById(req: Request) async throws -> Game {
        guard let gameId = UInt64(req.parameters.get("gameId") ?? "") else {
            throw Abort(.notFound)
        }

        // TODO:
        // if get game from db - else
        // get game from igdb + save to db
        guard let igdbGame = try await getGame(req: req, igdbId: gameId) else {
            throw Abort(.notFound)
        }

        // TODO: lag dto
        return Game(name: igdbGame.name, igdbId: igdbGame.id)
    }
}

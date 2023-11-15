import Fluent
import IGDB
import Vapor

struct SearchGamesRoutes: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let search = routes.grouped("search")

        search.group(":query") { search in
            search.get(use: index)
        }
    }

    func index(req: Request) async throws -> [Game] {
        let query = req.parameters.get("query") ?? ""
        let ble = try await searchGames(req: req, query: query)

        // try catch
        let games = try await Game.query(on: req.db).filter(\.$title ~~ query).all()

        print(ble)
        return games
        // TODO:
        // 1. Search IGDB for games
        // 2. Save results to database if not there
        // 3. Return results
    }
}

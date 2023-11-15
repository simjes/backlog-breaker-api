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

    func index(req: Request) async throws -> [SearchResponse] {
        let query = req.parameters.get("query") ?? ""
        let searchResults = try await searchGames(req: req, query: query)

        return searchResults
    }
}

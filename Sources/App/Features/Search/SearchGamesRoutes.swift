import Fluent
import IGDBClient
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
        let igdbResults = try await searchGames(req: req, query: query)

        let searchResults = igdbResults.map { result in
            SearchResponse(id: result.id, name: result.name)
        }

        return searchResults
    }
}

import IGDB_SWIFT_API
import Vapor

public func searchGames(req: Request, query: String) async throws -> [SearchResponse] {
    let (clientId, token) = await getIGDBCredentials(req: req)

    let apiCalypse = APICalypse()
        .fields(fields: "*")
        .search(searchQuery: query)

    let wrapper = IGDBWrapper(clientID: clientId, accessToken: token)

    return try await withCheckedThrowingContinuation { continuation in
        wrapper.search(apiCalypse: apiCalypse) { results in
            // TODO: flytt til APIet i stedet
            let searchResults = results.map { result in
                SearchResponse(id: result.id, name: result.name)
            }
            continuation.resume(returning: searchResults)
        } errorResponse: { ex in
            continuation.resume(throwing: ex)
        }
    }
}

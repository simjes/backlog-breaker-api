import IGDB_SWIFT_API
import Vapor

public func searchGames(req: Request, query: String) async throws -> [Proto_Search] {
    let (clientId, token) = await getIGDBCredentials(req: req)

    let apiCalypse = APICalypse()
        .fields(fields: "*")
        .search(searchQuery: query)

    let wrapper = IGDBWrapper(clientID: clientId, accessToken: token)

    return try await withCheckedThrowingContinuation { continuation in
        wrapper.search(apiCalypse: apiCalypse) { results in
            continuation.resume(returning: results)
        } errorResponse: { ex in
            continuation.resume(throwing: ex)
        }
    }
}

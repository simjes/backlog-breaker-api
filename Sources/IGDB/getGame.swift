import IGDB_SWIFT_API
import Vapor

public func getGame(req: Request, igdbId: UInt64) async throws -> Proto_Game? {
    let (clientId, token) = await getIGDBCredentials(req: req)

    let apiCalypse = APICalypse()
        .fields(fields: "*, cover.url")
        .where(query: "where id = \(igdbId);")

    let wrapper = IGDBWrapper(clientID: clientId, accessToken: token)

    return try await withCheckedThrowingContinuation { continuation in
        wrapper.games(apiCalypse: apiCalypse) { results in
            continuation.resume(returning: results.first)
        } errorResponse: { ex in
            continuation.resume(throwing: ex)
        }
    }
}

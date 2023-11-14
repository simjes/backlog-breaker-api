import Foundation
import IGDB_SWIFT_API
import Vapor

let baseUrl = "https://id.twitch.tv/oauth2/token"

var tokenCache: TokenCache?

public func getAccessToken(req: Request) async -> String {
    let clientId = Environment.get("TWITCH_CLIENT_ID") ?? ""
    let clientSecret = Environment.get("TWITCH_CLIENT_SECRET") ?? ""

    if tokenCache != nil {
        // 1 minute grace period
        let hasExpired = tokenCache!.expires < Date.now.addingTimeInterval(-60)
        if !hasExpired { return tokenCache!.accessToken }
    }

    do {
        let response = try await req.client.post("\(baseUrl)?client_id=\(clientId)&client_secret=\(clientSecret)&grant_type=client_credentials")
        let token = try response.content.decode(TokenResponse.self)
        tokenCache = TokenCache(accessToken: token.accessToken, expires: Date.now.addingTimeInterval(token.expiresIn))

        return token.accessToken
    } catch {
        // TODO: Handle or log the error — what do?
        print("Error occurred: \(error)")
        return ""
    }
}

public func searchGamesAsync(req: Request, query: String) async throws -> [Proto_Search] {
    let clientId = Environment.get("TWITCH_CLIENT_ID") ?? ""
    let token = await getAccessToken(req: req)

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

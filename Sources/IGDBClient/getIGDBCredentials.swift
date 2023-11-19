import Foundation
import IGDB_SWIFT_API
import Vapor

private let tokenBaseUrl = "https://id.twitch.tv/oauth2/token"
private var tokenCache: TwitchTokenCache?

internal func getIGDBCredentials(req: Request) async -> (clientId: String, token: String) {
    let clientId = Environment.get("TWITCH_CLIENT_ID") ?? ""
    let clientSecret = Environment.get("TWITCH_CLIENT_SECRET") ?? ""

    if tokenCache != nil {
        // 1 minute grace period
        let hasExpired = tokenCache!.expires < Date.now.addingTimeInterval(-60)
        if !hasExpired { return (clientId: clientId, token: tokenCache!.accessToken) }
    }

    do {
        let response = try await req.client.post("\(tokenBaseUrl)?client_id=\(clientId)&client_secret=\(clientSecret)&grant_type=client_credentials")
        let token = try response.content.decode(TwitchTokenResponse.self)
        tokenCache = TwitchTokenCache(accessToken: token.accessToken, expires: Date.now.addingTimeInterval(token.expiresIn))
        return (clientId: clientId, token: token.accessToken)
    } catch {
        // TODO: Handle or log the error — what do?
        print("Error occurred: \(error)")
        return (clientId: clientId, token: "")
    }
}

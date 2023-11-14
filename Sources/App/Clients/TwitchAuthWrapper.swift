import Foundation
import IGDB_SWIFT_API
import Vapor

let baseUrl = "https://id.twitch.tv/oauth2/token"

public func getAccessToken(req: Request) async -> TokenResponse? {
    let clientId = Environment.get("TWITCH_CLIENT_ID") ?? ""
    let clientSecret = Environment.get("TWITCH_CLIENT_SECRET") ?? ""

    // TODO: check if we have access token already

    do {
        let response = try await req.client.post("\(baseUrl)?client_id=\(clientId)&client_secret=\(clientSecret)&grant_type=client_credentials")
        return try response.content.decode(TokenResponse.self)
    } catch {
        // Handle or log the error
        print("Error occurred: \(error)")
        return nil // or return a default TokenResponse
    }
}

public func searchGamesAsync(req: Request, query: String) async throws -> [Proto_Search] {
    let clientId = Environment.get("TWITCH_CLIENT_ID") ?? ""
    let token = await getAccessToken(req: req)

    let apiCalypse = APICalypse()
        .fields(fields: "*")
        .search(searchQuery: query)

    let wrapper = IGDBWrapper(clientID: clientId, accessToken: token?.accessToken ?? "")

    return try await withCheckedThrowingContinuation { continuation in
        wrapper.search(apiCalypse: apiCalypse) { results in
            continuation.resume(returning: results)
        } errorResponse: { ex in
            continuation.resume(throwing: ex)
        }
    }
}

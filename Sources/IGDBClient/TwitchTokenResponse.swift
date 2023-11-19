import Foundation

internal struct TwitchTokenResponse: Codable {
    var accessToken: String
    var expiresIn: Double
    var tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}

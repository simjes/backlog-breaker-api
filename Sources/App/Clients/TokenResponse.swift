import Foundation

public struct TokenResponse: Codable {
    var accessToken: String
    var expiresIn: Double
    var tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}

public struct TokenCache: Codable {
    var accessToken: String
    var expires: Date
}

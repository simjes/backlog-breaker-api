import Foundation

internal struct TwitchTokenCache: Codable {
    var accessToken: String
    var expires: Date
}

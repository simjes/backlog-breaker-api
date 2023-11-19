import Foundation

public struct DiscordUser: Codable {
    let id: String // Snowflake
    let username: String
    let discriminator: String
    let globalName: String?
    let avatar: String?
    let bot: Bool?
    let system: Bool?
    let mfaEnabled: Bool?
    let banner: String?
    let accentColor: Int?
    let locale: String?
    let verified: Bool?
    let email: String?
    let flags: Int?
    let premiumType: Int?
    let publicFlags: Int?
    let avatarDecoration: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case discriminator
        case globalName = "global_name"
        case avatar
        case bot
        case system
        case mfaEnabled = "mfa_enabled"
        case banner
        case accentColor = "accent_color"
        case locale
        case verified
        case email
        case flags
        case premiumType = "premium_type"
        case publicFlags = "public_flags"
        case avatarDecoration = "avatar_decoration"
    }
}

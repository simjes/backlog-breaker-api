import Vapor

// TODO: put discord base url in .env
public func getDiscordUser(req: Request, token: String) -> EventLoopFuture<DiscordUser> {
    req.client.get("https://discord.com/api/v10/users/@me") { request in
        request.headers.bearerAuthorization = BearerAuthorization(token: token)
    }.flatMapThrowing { response in
        try response.content.decode(DiscordUser.self)
    }
}

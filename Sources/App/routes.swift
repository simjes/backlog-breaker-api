import DiscordClient
import Fluent
import ImperialDiscord
import Vapor

func routes(_ app: Application) throws {
    let baseUrl = app.http.server.configuration.origin

    app.get { _ async in
        "It works!"
    }

    app.get("hello") { _ async -> String in
        "Hello, world!"
    }

    try app.register(collection: SearchGamesRoutes())
    try app.register(collection: GamesRoutes())

    // TODO: discord sin callback url er fucked i source — finn ut dette med auth0 heller
    try app.routes.oAuth(from: Discord.self, authenticate: "discord", callback: "\(baseUrl)/discord-auth-complete", scope: ["identify email"]) { request, token in

        let discordUserFuture = getDiscordUser(req: request, token: token)
        discordUserFuture.whenSuccess { _ in
            // TODO: add user to databse if not already there
            // Handle success - `discordUser` is available here
        }

        discordUserFuture.whenFailure { _ in
            // TODO: we don't know if the user exists in our database so we cannot continue?
            // Handle error
            // For example: throw Abort(.unauthorized)
        }

        print(token)
        return request.eventLoop.future(request.redirect(to: "/"))
    }
}

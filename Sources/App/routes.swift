import Fluent
import ImperialDiscord
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: SearchGamesRoutes())
    try app.register(collection: GamesRoutes())
    
    try app.routes.oAuth(from: Discord.self, authenticate: "discord", callback: "discord-auth-complete") { (request, token) in
        // TODO: sync user to db if not there?
        print(token)
        return request.eventLoop.future(request.redirect(to: "/"))
    }
}

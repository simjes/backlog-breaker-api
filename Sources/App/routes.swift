import Fluent
// import ImperialDiscord
import ImperialAuth0
import Vapor

func routes(_ app: Application) throws {
    // TODO: update Imperial docs eller gjør dette inni liben?
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
//    try app.routes.oAuth(from: Discord.self, authenticate: "discord", callback: "http://127.0.0.1:8080/callback", scope: ["identify email"]) { request, token in
//
//        // email    enables /users/@me to return an email
//        // TODO: sync user to db if not there?
//        print(token)
//        return request.eventLoop.future(request.redirect(to: "/"))
//    }

    try app.routes.oAuth(from: Auth0.self, authenticate: "login", callback: "\(baseUrl)/callback") { request, token in

        // email    enables /users/@me to return an email
        // TODO: sync user to db if not there?
        print(token)
        return request.eventLoop.future(request.redirect(to: "/"))
    }
}

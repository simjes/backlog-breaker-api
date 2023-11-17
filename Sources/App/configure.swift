import Fluent
import FluentMySQLDriver
import NIOSSL
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.middleware.use(app.sessions.middleware)

    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .mysql)

    app.migrations.add(CreateGame())
    app.migrations.add(UpdateGame_AddImageUrl())
    app.migrations.add(UpdateGame_AddImageId())
    app.migrations.add(UpdateGame_IndexIgdbId())
    app.migrations.add(UpdateGame_UniqueIgdbId())

    // register routes
    try routes(app)
}

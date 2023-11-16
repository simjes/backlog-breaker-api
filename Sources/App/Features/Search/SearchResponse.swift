import Vapor

public struct SearchResponse: Content {
    let id: UInt64
    let name: String
}

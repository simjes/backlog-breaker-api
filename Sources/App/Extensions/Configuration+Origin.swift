import Vapor

extension HTTPServer.Configuration {
    var origin: String {
        let scheme = tlsConfiguration == nil ? "http" : "https"
        let host = hostname
        let port = port
        return "\(scheme)://\(host):\(port)"
    }
}

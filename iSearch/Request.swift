import Foundation

class Request {
    private static let baseURL = URL(string: "https://itunes.apple.com/search")!
    private static let mediaType: String = "entity=musicVideo"
    
    static func getURLPath(queryTerm: String) -> URLRequest {
        let encodedQueryTerm = queryTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var request = URLRequest(url: URL(string: "\(baseURL)?term=\(encodedQueryTerm)&\(mediaType)")!)
        request.httpMethod = "GET"
        return request
    }
}

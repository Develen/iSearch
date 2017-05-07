import Foundation

class Request {
    
    static func getURLPath(queryTerm: String) -> URLRequest {
        let encodedQueryTerm = queryTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var request = URLRequest(url: URL(string: "\(URLRequestConstant.baseURL)?term=\(encodedQueryTerm)&entity=\(URLRequestConstant.mediaType)")!)
        request.httpMethod = "GET"
        return request
    }
}

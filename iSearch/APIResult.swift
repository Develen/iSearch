import Foundation

enum APIResult<T> {
    case success(T)
    case failure(Error)
    case noInternetConnection
    case invalidJSON
    case unexpectedJSONContent
}

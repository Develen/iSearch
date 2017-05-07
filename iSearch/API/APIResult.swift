import Foundation

enum APIResult<T> {
    case success(T)
    case failure(Error)
}

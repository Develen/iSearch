import Foundation

enum APIResult<T> {
    case Success(T?)
    case Failure(Error)
    case NoInternetConnection
}

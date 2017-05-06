import Foundation

enum ErrorList: Error {
    case invalidJSON
    case unexpectedJSONContent
    case noInternetConnection
}

import Foundation

protocol APIClient {
    var configuration: URLSessionConfiguration {get}
    var session: URLSession {get}
    
    func dataTaskWithRequest(request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTask?
    func fetch<T>(request: URLRequest, parse: @escaping (Data) throws -> T?, completion: @escaping (APIResult<T>) -> Void)
}

extension APIClient {
    func dataTaskWithRequest (request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTask? {
        let task = session.dataTask(with: request) {
            (data, response, error) in
            guard let HTTPResponse = response as? HTTPURLResponse else {
                completion(nil, nil, error)
                return
            }
            if data == nil {
                completion(nil, HTTPResponse, error)
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    completion(data, HTTPResponse, nil)
                default:
                    completion(nil, HTTPResponse, error)
                }
            }
        }
        return task
    }
    
    func fetch<T>(request: URLRequest, parse: @escaping (Data) throws -> T?, completion: @escaping (APIResult<T>) -> Void) {
        let task = dataTaskWithRequest(request: request) {
            (json, response, error) in
            DispatchQueue.main.async {
                guard response != nil else {
                    completion(APIResult.failure(ErrorType.noInternetConnection))
                    return
                }
                guard let json = json else {
                   completion(APIResult.failure(error!))
                    return
                }
                do {
                    let value = try parse(json)
                    completion(APIResult.success(value!))
                }  catch let error as NSError {
                    completion(APIResult.failure(error))
                }
            }
        }
        task!.resume()
    }

}

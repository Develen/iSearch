import Foundation

protocol APIClient {
    var configuration: URLSessionConfiguration {get}
    var session: URLSession {get}
    
    func JSONTaskWithRequest(request: URLRequest, completion: (NSDictionary?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTask?
    func fetch<T>(request: URLRequest, parse: (NSDictionary) -> T?, completion: (APIResult<T>) -> Void)
}

extension APIClient {
    func JSONTaskWithRequest (request: URLRequest, completion: @escaping (NSDictionary?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTask? {
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
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        completion(json, HTTPResponse, nil)
                    } catch let error as NSError {
                        completion(nil, HTTPResponse, error)
                    }
                default: break
                }
            }
        }
        return task
    }
    
    func fetch<T>(request: URLRequest, parse: @escaping (NSDictionary) -> T?, completion: @escaping (APIResult<T>) -> Void) {
        let task = JSONTaskWithRequest(request: request) {
            (json, response, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(APIResult.NoInternetConnection)
                    return
                }
                let value = parse(json)
                if value == nil {
                    completion(APIResult.Failure(error!))
                } else {
                    completion(APIResult.Success(value))
                }
            }
        }
        task!.resume()
    }
}

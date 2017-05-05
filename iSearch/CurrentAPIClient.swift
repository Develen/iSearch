import Foundation

class CurrentAPIClient: APIClient {
    private var request: URLRequest
    let configuration: URLSessionConfiguration = .default
    lazy var session: URLSession = {
         return URLSession(configuration: self.configuration)
    }()
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func fetchCurrentITunesEntity(completion: @escaping (APIResult<[ITunesEntity]>) -> Void) {
        fetch(request: request, parse: ITunesParser.parseJSON, completion: completion)
    }
}

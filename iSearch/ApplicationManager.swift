import Foundation

class ApplicationManager {
    static let sharedInstance = ApplicationManager()
    var gotCurrentITunesEntity:([ITunesEntity])-> () = {iTunesEntity in return}
    var gotError: (Error) -> () = {error in return}
    
    func start(queryTerm: String) {
        CurrentAPIClient(request: Request.getURLPath(queryTerm: queryTerm)).fetchCurrentITunesEntity {
            result in
            switch result {
            case .success(let currentITunesEntity):
                self.gotCurrentITunesEntity(currentITunesEntity)
            case .failure(let error):
                self.gotError(error)
            }
        }
    }
}

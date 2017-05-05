import Foundation

class ITunesEntity {
    private(set) var trackName: String
    private(set) var image: String
    
    init(trackName: String, image: String) {
        self.trackName = trackName
        self.image = image
    }
}

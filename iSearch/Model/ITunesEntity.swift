import Foundation

class ITunesEntity {
    private(set) var trackName: String
    private(set) var image: String
    private(set) var artistName: String
    
    init(trackName: String, image: String, artistName: String) {
        self.trackName = trackName
        self.image = image
        self.artistName = artistName
    }
}

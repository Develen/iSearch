import Foundation

class ITunesParser {
    private static let iTunesResultKey = "results"
    private static let firstITunesKeyToFillResult = "trackName"
    private static let secondITunesKeyToFillResult = "artworkUrl60"
    private static let thirdITunesKeyToFillResult = "artistName"
    
    static func parseJSON(json: Data) throws -> [ITunesEntity] {
        var iTunesEntity: NSDictionary?
        
        do {
            iTunesEntity = try JSONSerialization.jsonObject(with: json, options: []) as? NSDictionary
        } catch {
            throw ErrorType.invalidJSON
        }
        return try parseITunesEntity(content: iTunesEntity!)
    }
    
    private static func parseITunesEntity(content: NSDictionary) throws -> [ITunesEntity] {
        var iTunesEntity: [ITunesEntity] = []
        
        guard let iTunesContent = content[ITunesParser.iTunesResultKey] as? [NSDictionary] else {
         throw ErrorType.unexpectedJSONContent
        }
        for oneContent in iTunesContent {
            guard let trackName = oneContent[ITunesParser.firstITunesKeyToFillResult],
                let image = oneContent[ITunesParser.secondITunesKeyToFillResult],
            let artistName = oneContent[ITunesParser.thirdITunesKeyToFillResult] else {
                    continue
                    //TODO: log error massage
            }
            iTunesEntity.append(ITunesEntity(trackName: trackName as! String, image: image as! String, artistName: artistName as! String))
        }
        return iTunesEntity
    }
    
}

import Foundation

class ITunesParser {
    
    static func parseJSON(json: Data) throws -> [ITunesEntity] {
        var iTunesEntity: NSDictionary?
        
        do {
            iTunesEntity = try JSONSerialization.jsonObject(with: json, options: []) as? NSDictionary
        } catch {
            throw JSONParsingError.invalidJSON
        }
        return try parseITunesEntity(content: iTunesEntity!)
    }
    
    private static func parseITunesEntity(content: NSDictionary) throws -> [ITunesEntity] {
        var iTunesEntity: [ITunesEntity] = []
        
        guard let iTunesContent = content[JSONParsingConstant.iTunesResultKey] as? [NSDictionary] else {
            throw JSONParsingError.unexpectedJSONContent
        }
        for oneContent in iTunesContent {
            guard let trackName = oneContent[JSONParsingConstant.firstITunesKeyToFillResult],
                let image = oneContent[JSONParsingConstant.secondITunesKeyToFillResult],
                let artistName = oneContent[JSONParsingConstant.thirdITunesKeyToFillResult] else {
                    continue
                    //TODO: log error massage
            }
            iTunesEntity.append(ITunesEntity(trackName: trackName as! String, image: image as! String, artistName: artistName as! String))
        }
        return iTunesEntity
    }
    
}

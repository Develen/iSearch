import Foundation

class ITunesParser {
    private static  let iTunesResultKey = "results"
    
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
        
        guard let iTunesContent = content[iTunesResultKey] as? [NSDictionary] else {
         throw ErrorType.unexpectedJSONContent
        }
        for oneContent in iTunesContent {
            guard let trackName = oneContent["trackName"],
                let image = oneContent["artworkUrl60"] else {
                    continue
                    //TODO: log error massage
            }
            iTunesEntity.append(ITunesEntity(trackName: trackName as! String, image: image as! String))
        }
        return iTunesEntity
    }
    
}

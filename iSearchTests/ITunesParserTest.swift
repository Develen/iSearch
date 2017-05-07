import XCTest
@testable import iSearch

class ITunesParserTest: XCTestCase {
    
    func test_parseJSON_validJSONWithThreeEntities_ThreeEntity() throws {
        var entities: [ITunesEntity]? = nil
        var error : Error? = nil
        let data = try readFileContent(name: "validJSON_ThreeEntities", fileExtension: "json")
        do {
            entities = try ITunesParser.parseJSON(json: data as Data)
        } catch let currentError as NSError {
            error = currentError
        }
        XCTAssert(error == nil , "no error in parsing valid JSON")
        XCTAssertEqual(entities?.count, 3, "amount of entities is 3")
        XCTAssert(entities?[0].artistName == "Name1", "right artist name of first entity")
        XCTAssert(entities?[0].trackName == "Track1", "right track name of first entity")
        XCTAssert(entities?[0].image == "ImageURL1", "right image string url of first entity")
        XCTAssert(entities?[1].artistName == "Name2", "right artist name of second entity")
        XCTAssert(entities?[1].trackName == "Track2", "right track name of second entity")
        XCTAssert(entities?[1].image == "ImageURL2", "right image string url of second entity")
        XCTAssert(entities?[2].artistName == "Name3", "right artist name of third entity")
        XCTAssert(entities?[2].trackName == "Track3", "right track name of third entity")
        XCTAssert(entities?[2].image == "ImageURL3", "right image string url of third entity")
    }
    
    func test_parseJSON_invalidJSONFormat_ThrowErrorInvalidJSON() throws {
        var entities: [ITunesEntity]? = nil
        var error : Error? = nil
        let data = try readFileContent(name: "invalidJSON", fileExtension: "json")
        do {
            entities = try ITunesParser.parseJSON(json: data as Data)
        } catch let currentError as NSError {
            error = currentError
        }
        XCTAssert(error as? JSONParsingError == JSONParsingError.invalidJSON , "invalid JSON content")
    }
    
    func test_parseJSON_invalidJSONParentContent_ThrowErrorUnexpectedJSONContent() throws {
        var entities: [ITunesEntity]? = nil
        var error : Error? = nil
        let data = try readFileContent(name: "invalidJSONParentContent", fileExtension: "json")
        do {
            entities = try ITunesParser.parseJSON(json: data as Data)
        } catch let currentError as NSError {
            error = currentError
        }
        XCTAssert(error as? JSONParsingError == JSONParsingError.unexpectedJSONContent , "error unexpected JSON content")
    }
    
    func test_parseJSON_invalidJSONContent_EmptyArrayOfITunesEntity() throws {
        var entities: [ITunesEntity]? = nil
        var error : Error? = nil
        let data = try readFileContent(name: "incorrectJSONToRecieveSearchResult", fileExtension: "json")
        do {
            entities = try ITunesParser.parseJSON(json: data as Data)
        } catch let currentError as NSError {
            error = currentError
        }
        XCTAssert(entities?.count == 0 , "no keys to fill array with objects of ITunesEntity")
    }
    
    private func readFileContent(name: String, fileExtension: String) throws -> NSData {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: name, ofType: fileExtension, inDirectory: nil)
        guard let correctPath = path else {
            throw TestError.invalidFilePath
        }
        return try NSData(contentsOfFile: correctPath)
    }
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
}

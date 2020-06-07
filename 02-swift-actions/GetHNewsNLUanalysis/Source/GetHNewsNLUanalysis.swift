import Foundation
import SwiftCloudant
import SwiftyJSON
import Dispatch

struct Input: Codable {
    let newsIds: String?
    let dbUsername: String?
    let dbPassword: String?
    let cloudantURL: String?
}
struct Output: Codable {
    let NLUProcessedHNewsJSON: JSON
}
func main(param: Input, completion: (Output?, Swift.Error?) -> Void) -> Void {
    var result = Output(NLUProcessedHNewsJSON: ["rev":""] as JSON)
    // MARK: Create a CouchDBClient
    // use OpenWhisk parameters for that
    // or hardcode them here (not recommended!!)

    let cloudantURL = URL(string: param.cloudantURL ?? "<some id here from ibm cloud: like https://XYZ.cloudantnosqldb.appdomain.cloud>")!
    let client = CouchDBClient(url:cloudantURL,
        username: (param.dbUsername ?? "<some id here from ibm cloud: like XYZ-bluemix>"),
        password: (param.dbPassword ?? "<some password>"))

    let dbName = "hacker-news-nlu"

    //get the id from param or get an example id from the current (202006) set of articles
    let newsId = param.newsIds ?? "23301402" 
    var rev = ""
    var hnNLUid = ""
    var hnNLUtitle = ""
    var hnNLUkeywords = ""
    var hnNLUentities = ""
    var hnNLUconcepts = ""
    var hnNLUcategories = ""
    var emptyDictionary = [[String: AnyObject]]()
    let _whisk_semaphore = DispatchSemaphore(value: 0)
    let read = GetDocumentOperation(id: newsId, databaseName: dbName) { (response, httpInfo, error) in
        if let error = error {
            print("Encountered an error while reading a document. Error: \(error)")
            print("Error in Read document rev: \(newsId)")
            result = Output(NLUProcessedHNewsJSON: [] as JSON)
            _whisk_semaphore.signal()
        } else {
            rev = response?["_rev"] as! String as String
            hnNLUid = response?["newsid"] as! String as String
            hnNLUtitle = response?["title"] as! String as String
            hnNLUkeywords = response?["keyword"] as! String as String
            hnNLUentities = response?["entities"] as! String as String
            hnNLUconcepts = response?["concepts"] as! String as String
            hnNLUcategories = response?["categories"] as! String as String
            let responseArray = [["newsid":hnNLUid, "title":hnNLUtitle,
             "keywords":hnNLUkeywords, "entities":hnNLUentities, "concepts":hnNLUconcepts, "categories":hnNLUcategories,
             "request-newsid":param.newsIds]]  as JSON
            result = Output(NLUProcessedHNewsJSON: responseArray) 
            _whisk_semaphore.signal()
        }
    }
    client.add(operation: read)
    _ = _whisk_semaphore.wait(timeout: .distantFuture)
    completion(result, nil)    
}
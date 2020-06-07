//
//  InsertHNewsIdsCloudant.swift
//  hacker-news Serverless MBaaS
//
//  Created by Marek Sadowski on 5/28/20.
//  connect with me: serverless.swift@roboticsinventions.com
//  Apache 2 OpenSource License
//


import Foundation
import SwiftCloudant
import KituraNet
import SwiftyJSON
import Dispatch

struct Input: Codable {
    let newsIds: JSON?
    let dbUsername: String?
    let dbPassword: String?
    let cloudantURL: String?
}
struct Output: Codable {
    let noRecords: String
}
func main(param: Input, completion: (Output?, Swift.Error?) -> Void) -> Void {
    //start the counter
    var result = Output(noRecords: "0")
    var insertedHNewsIdRecords = 0

    // MARK: Create a CouchDBClient
    // use OpenWhisk parameters for that
    // or hardcode them here (not recommended!!)

    let cloudantURL = URL(string: param.cloudantURL ?? "<some id here from ibm cloud: like https://XYZ.cloudantnosqldb.appdomain.cloud>")!
    let client = CouchDBClient(url:cloudantURL,
        username: (param.dbUsername ?? "<some id here from ibm cloud: like XYZ-bluemix>"),
        password: (param.dbPassword ?? "<some password>"))
    let dbName = "hacker-news-ids"
    
    //go thru the list
    //var json = JSON(data: newsIds)

    //go thru the list as an example couple ids from the current (202006) set of articles
    var json = newsIds? ?? "[23303037,23304614,23304081,23304788,23304194,23301402,23302549,23304536,23304457,23303583,23305420,23296353,23302102,23302250]"
    //go thru the list
    json = json.replacingOccurrences(of: "[", with: "")
    json = json.replacingOccurrences(of: "]", with: "")
    let array = json.components(separatedBy: ",")
    
    //prepare documents for BULK Load
    var news = [["_id":"test1", "newsId":"test1"]]
    for newsId in array {
            print(newsId, insertedHNewsIdRecords)
            news.append(["_id":newsId, "newsId":newsId])
            insertedHNewsIdRecords = insertedHNewsIdRecords+1
    }
    print("counter: \(insertedHNewsIdRecords)")
        

    // MARK: loading bulk of HNews Articles
    //insert a hackerNews ID unless it exists - swiftCloudant takes care of it

    let bulkDocs = PutBulkDocsOperation(databaseName: dbName, documents: news) { (response, httpInfo, error) in
    if let error = error {
            print("Encountered an error while writing a document. Error: \(error)")
        }
        else {
            //print("write bulk document: \(response)")
        }
    }
    client.add(operation: bulkDocs)

    //return counter
    result = Output(noRecords: "\(insertedHNewsIdRecords)")
    completion(result, nil)    
}
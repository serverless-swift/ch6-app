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
import SwiftyJSON
import Dispatch

struct Input: Codable {
    let newsIds: [Int64]?
    let dbUsername: String?
    let dbPassword: String?
    let cloudantURL: String?
}
struct Output: Codable {
    let noRecords: String
}
func main(param: Input, completion: (Output?, Swift.Error?) -> Void) -> Void {
    let CapRecordAmount = 30 //limitting the amount of the calls out of 500
    var result = Output(noRecords: "0")
  
    // MARK: Create a CouchDBClient
    // use OpenWhisk parameters for that
    // or hardcode them here (not recommended!!)

    let cloudantURL = URL(string: param.cloudantURL ?? "<some id here from ibm cloud: like https://XYZ.cloudantnosqldb.appdomain.cloud>")!
    let client = CouchDBClient(url:cloudantURL,
        username: (param.dbUsername ?? "<some id here from ibm cloud: like XYZ-bluemix>"),
        password: (param.dbPassword ?? "<some password>"))
    let dbName = "hacker-news-ids"
    
    //go thru the list as an example couple ids from the current (202006) set of articles
    var longarray = param.newsIds ?? [23425041,23426538,23420786,23426189,23414793,23418699,23426154,23422311]
    var idsresponse = ""
    var insertedHNewsIdRecords = 0
    var news = [["_id":"t1", "newsId":"t1"]]
    for iterator in longarray{
        //running for only limitted amount of the records
        if (insertedHNewsIdRecords<CapRecordAmount) {
            idsresponse=idsresponse+" "+String(iterator)
            news.append(["_id":String(iterator), "newsId":String(iterator)])
        }
        insertedHNewsIdRecords = insertedHNewsIdRecords+1
    }        
    //print(idsresponse)

    let bulkDocs = PutBulkDocsOperation(databaseName: dbName, documents: news) { (response, httpInfo, error) in
    if let error = error {
            print("Encountered an error while writing a document. Error: \(error)")
        }
        else {
            print("attempted to load the following ids: \(idsresponse)" )
        }
    }
    client.add(operation: bulkDocs)
    //result = Output(noRecords: "\(insertedHNewsIdRecords)")
    result = Output(noRecords: idsresponse)
    completion(result, nil)    
}

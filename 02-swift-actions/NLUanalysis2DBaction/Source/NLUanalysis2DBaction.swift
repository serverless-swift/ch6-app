//
//  NLUanalysis2DBaction.swift
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
    let dbUsername: String?
    let dbPassword: String?
    let cloudantURL: String?
    let newsId: String
    let HNUrl: String
    let title: String
    let keywords: String
    let entities: String
    let concepts: String
    let categories: String
}
struct Output: Codable {
    let HNdbInfo: String
}
func main(param: Input, completion: (Output?, Swift.Error?) -> Void) -> Void {
    //start the counter
    var result = Output(HNdbInfo: "failed")
    var HNrecord = ""

    // MARK: Create a CouchDBClient
    // use OpenWhisk parameters for that
    // or hardcode them here (not recommended!!)

    let cloudantURL = URL(string: param.cloudantURL ?? "<some id here from ibm cloud: like https://XYZ.cloudantnosqldb.appdomain.cloud>")!
    let client = CouchDBClient(url:cloudantURL,
        username: (param.dbUsername ?? "<some id here from ibm cloud: like XYZ-bluemix>"),
        password: (param.dbPassword ?? "<some password>"))
    let dbName = "hacker-news-nlu"
    
    
    
    // Create a document
    let insert = PutDocumentOperation(id: param.newsId, 
        body: ["newsid":param.newsId, "title":param.title, "HNUrl":param.HNUrl, "keyword":param.keywords,
        "entities":param.entities, "concepts":param.concepts, "categories":param.categories],
        databaseName: dbName) {(response, httpInfo, error) in
        if let error = error {
            print("Encountered an error while writing a document. Error: \(error)")
        }
        else {
            //print("ok inserted HN id \(response?["rev"] as! String)")
            HNrecord = "Created document \(response as! String) /n \(response?["id"] as! String) with revision id \(response?["rev"] as! String)"
        }
    }
    client.add(operation:insert)
    
    //return doc id, response
    result = Output(HNdbInfo: HNrecord)
    completion(result, nil)     
}

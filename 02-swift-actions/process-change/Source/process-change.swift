//
//  process-change.swift
//  hacker-news Serverless MBaaS
//
//  Created by Marek Sadowski on 5/28/20.
//  connect with me: serverless.swift@roboticsinventions.com
//  Apache 2 OpenSource License
//

import Foundation
import KituraNet
import SwiftyJSON

struct Input: Codable {
    let newsId: String?
    let _rev: String?
}
struct Output: Codable {
    let newsId: String
    let HNUrl: String
    let rev: String?
    let title: String?
}
func main(param: Input, completion: (Output?, Swift.Error?) -> Void) -> Void {
    var result = Output(newsId: "no ids", HNUrl: "http://openwhisk.apache.org", rev: "rev-????", title:"Apache OpenWhisk")

    //Using KituraNet make an API call to Hacker News - check the link for the given id alike HN article: 23304614
    //let apiUrlTop100HNIds = "https://hacker-news.firebaseio.com/v0/item/23304614.json"
    let request: [ClientRequest.Options] = [ 
        .method("GET"),
        .schema("https://"),
        .hostname("hacker-news.firebaseio.com"),
        .path("/v0/item/\(param.newsId as! String).json")
    ]
    var json: JSON? = nil
    let req = HTTP.request(request) { resp in
        if let resp = resp, resp.statusCode == HTTPStatusCode.OK {
        do {
            var data = Data()
            try resp.readAllData(into: &data)
            try json = JSON(data: data)
        } catch {
            print("Error \(error)")
        }
        } else {
            print("Status error code or nil reponse received from App ID server.")
        }
    }
    req.end()

    let newsJson = JSON.init(parseJSON: json!.rawString() as! String)
    var HNUrl = "http://openwhisk.apache.org"
    var HNTitle = "Apache OpenWhisk"
    if let url = newsJson["url"].string {
        HNUrl = url
    }
    if let title = newsJson["title"].string {
        HNTitle = title
    }
    result = Output(newsId: (param.newsId  as! String), HNUrl: HNUrl, rev: (param._rev  as! String), title: HNTitle)   
    completion(result, nil)
}
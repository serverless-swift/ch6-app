//
//  GetAllHNewsIds.swift
//  hacker-news Serverless MBaaS
//
//  Created by Marek Sadowski on 5/28/20.
//  connect with me: serverless.swift@roboticsinventions.com
//  Apache 2 OpenSource License
//

import Foundation
import KituraNet
import SwiftyJSON


struct Output: Codable {
    let newsIds: JSON
}
func main(completion: (Output?, Swift.Error?) -> Void) -> Void {
    var result = Output(newsIds: "0")

    //Using KituraNet make an API call to Hacker News - check the link
    //"https://hacker-news.firebaseio.com/v0/topstories.json"
    let request: [ClientRequest.Options] = [ 
        .method("GET"),
        .schema("https://"),
        .hostname("hacker-news.firebaseio.com"),
        .path("/v0/topstories.json")
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
    result = Output(newsIds: json as! JSON)
    completion(result, nil)
}
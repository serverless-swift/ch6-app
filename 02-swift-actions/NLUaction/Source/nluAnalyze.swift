//
//  nluAnalyze.swift
//  hacker-news Serverless MBaaS
//
//  Created by Marek Sadowski on 5/28/20.
//  connect with me: serverless.swift@roboticsinventions.com
//  Apache 2 OpenSource License
//

import SwiftyRequest
import NaturalLanguageUnderstandingV1
import Dispatch

struct Input: Codable {
    let newsId: String
    let HNUrl: String
    let rev: String?
    let title: String?
    let serviceURL: String?
    let apiKey: String?
}
struct Output: Codable {
    let newsId: String
    let HNUrl: String
    let title: String
    let keywords: String
    let entities: String
    let concepts: String
    let categories : String
}
func main(param: Input, completion: (Output?, Error?) -> Void) -> Void {
    //set your max number of responses from NLU - you might want to also tweak the response on base of the accuracy ie. above 50%
    let maxKeywords = 5
    let maxConcepts = 2
    let maxEntities = 2
    let maxCategories = 3

    var result = Output(newsId: param.newsId, HNUrl: param.HNUrl, title: (param.title ?? "no title"), 
    keywords: "the keywords", 
    entities: "some entities", concepts: "some concepts", categories: "some cat")
    //print("Log NLU analysis: \(result.keywords) | \(result.entities) | \(result.concepts)")

    let _whisk_semaphore = DispatchSemaphore(value: 0)

    // MARK: setting up the apiKey and iamURL=serviceURL in parameters
    let authenticator = WatsonIAMAuthenticator(apiKey: (param.apiKey ?? "<some apiKey here from ibm cloud: like XYZ>"))
    let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(version: "2019-07-12", authenticator: authenticator)
    naturalLanguageUnderstanding.serviceURL =  (param.serviceURL ?? "<some serviceURL here from ibm cloud adjusted for your region like https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/instances/some-number-here>")

    let keywords = KeywordsOptions(limit: maxKeywords)
    let concepts = ConceptsOptions(limit: maxConcepts)
    let entities = EntitiesOptions(limit: maxEntities)
    let categories = CategoriesOptions(limit: maxCategories)    
    let features = Features(concepts: concepts, emotion: EmotionOptions(), entities: entities, keywords: keywords, sentiment: SentimentOptions(), categories: CategoriesOptions())
        
    naturalLanguageUnderstanding.analyze(features: features, url: (param.HNUrl ?? "https://openwhisk.apache.org/")) {
        response, error in
        guard let analysis = response?.result else {
            print(error?.localizedDescription ?? "unknown error")
                 _whisk_semaphore.signal()
            return
        }

        //print(analysis)
        var jsonConcepts = [[String: Any]]()
        var jsonCategories = [[String: Any]]()
        var jsonEmotion = [String: Any]()
        var jsonSentiment = [String: Any]()
        var jsonEntities = [[String: Any]]()
        var jsonKeywords = [[String: Any]]()
    
        for concept in analysis.concepts! {
            jsonConcepts.append(["text": concept.text! as Any, "relevance": concept.relevance! as Any])
        }
        for category in analysis.categories! {
            jsonCategories.append(["label": category.label! as Any, "score": category.score! as Any])
        }
        jsonEmotion = ["anger": analysis.emotion?.document?.emotion?.anger! as Any, "joy": analysis.emotion?.document?.emotion?.joy! as Any, "disgust": analysis.emotion?.document?.emotion?.disgust! as Any, "fear": analysis.emotion?.document?.emotion?.fear! as Any, "sadness": analysis.emotion?.document?.emotion?.sadness! as Any]
        jsonSentiment = ["label": analysis.sentiment?.document?.label! as Any, "score": analysis.sentiment?.document?.score! as Any]
        for entity in analysis.entities! {
            jsonEntities.append(["text": entity.text! as Any, "type": entity.type! as Any, "relevance": entity.relevance! as Any])
        }
        for keyword in analysis.keywords! {
            jsonKeywords.append(["text": keyword.text! as Any, "relevance": keyword.relevance! as Any])
        }
        var total_json = [String: Any]()
        total_json["concepts"] = jsonConcepts as Any
        total_json["categories"] = jsonCategories as Any
        total_json["emotion"] = jsonEmotion as Any
        total_json["sentiment"] = jsonSentiment as Any
        total_json["entities"] = jsonEntities as Any
        total_json["keywords"] = jsonKeywords as Any
        total_json["retrieved_url"] = param.HNUrl
        
        result = Output(newsId: param.newsId, HNUrl: param.HNUrl, title: (param.title ?? "no title"), keywords: analysis.keywords?.description as! String, 
            entities: analysis.entities?.description as! String, concepts: analysis.concepts?.description as! String, categories: analysis.categories?.description as! String)
            //print("Log NLU analysis: \(result.keywords) | \(result.entities) | \(result.concepts)")

        _whisk_semaphore.signal()
    }
    _ = _whisk_semaphore.wait(timeout: .distantFuture)
    completion(result, nil)
}
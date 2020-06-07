//
//  NewsTableViewController.swift
//  hacker-news
//
//  Created by Marek Sadowski on 5/28/20.
//  connect with me: serverless.swift@roboticsinventions.com
//  Apache 2 OpenSource License
//


import UIKit
import OpenWhisk
import SwiftyJSON

// changes for H-News
struct News {
    var newsId: String
    var title: String
 
    var concepts : String
    var keywords : String
    var entities : String
    var categories : String
    var sentiment : String
    var emotion : String
    var relations : String
    var roles : String
}

//https://codereview.stackexchange.com/questions/209643/implementing-componentsseparatedby-method-in-swift
extension StringProtocol {
    func components<T>(separatedBy separatorString: T) -> [String] where T: StringProtocol {

        var currentIndex = 0; var stringBuffer = ""; var separatedStrings:[String] = []

        forEach { (character) in

            if String(character) == separatorString {
                separatedStrings.append(stringBuffer); stringBuffer = ""
            } else {
                stringBuffer += .init(character)
            }

            if currentIndex == lastIndex { separatedStrings.append(stringBuffer) }
            currentIndex += 1
        }
        return separatedStrings
    }
}

extension Collection {
    var lastIndex:Int {
        get {
            return self.count - 1
        }
    }
}

class NewsTableViewController: UITableViewController {
    
    var isInitial = true
    
    /**
     Update your whisk data - follow the instructions in chapter 4 and chapter 6 of Serverless Swift@Apress 2020
     by Marek Sadowski and Lennart Frantzell
     
    // Change to your whisk app key and secret.
    let WhiskAppKey = "<your WhiskAppKey>"
    let WhiskAppSecret = "<your WhiskAppSecret"
    
    // the URL for Whisk backend
    let baseUrl: String? = "https://openwhisk.ng.bluemix.net"

    // Choice: specify components
    let MyNamespace: String = "serverless.swift@roboticsind.com_dev"
    
    // Specify you package
    let MyPackage: String? = "hacker-news-pak"
*/
    
    //Update your whisk data - follow the instructions in chapter 4 and chapter 6 of Serverless Swift@Apress 2020
    //by Marek Sadowski and Lennart Frantzell
     
    // Change to your whisk app key and secret.
    let WhiskAppKey = "<your WhiskAppKey>"
    let WhiskAppSecret = "<your WhiskAppSecret"
    
    // the URL for Whisk backend something like "https://openwhisk.ng.bluemix.net"
    let baseUrl: String? = "<the URL for Whisk backend>"

    // Choice: specify components "serverless.swift@roboticsind.com_dev"
    let MyNamespace: String = "<your CloudFoundry namespace>"
    
    // Specify you package
    let MyPackage: String? = "hacker-news-pak"
    
    // The actions to invoke.
    let MyWhiskAction0: String = "analyzeTopHNewsSequence"
    let MyWhiskAction1: String = "getAllHNewsIds"
    let MyWhiskAction2: String = "GetHNewsNLUanalysis"

    var MyActionParameters: [String:AnyObject]? = nil
    let HasResult: Bool = true // true if the action returns a result

    var session: URLSession!
    
    //using a WhiskButton to setup the call to the Serverless MBaaS
    var whiskButton: WhiskButton!
    let whiskHelper = WhiskButton()
    
    var hackerNews = [
        News(newsId: "1", title: "title 1", concepts: "concepts", keywords: "keywords, keywords ", entities: "entities, entities ", categories: "categories ", sentiment: "0.1", emotion: "happy", relations: "relations", roles: "roles"),
        News(newsId: "2", title: "title 2", concepts: "concepts", keywords: "keywords, keywords ", entities: "entities, entities ", categories: "categories ", sentiment: "0.1", emotion: "happy", relations: "relations", roles: "roles"),
        News(newsId: "3", title: "title 3", concepts: "concepts", keywords: "keywords, keywords ", entities: "entities, entities ", categories: "categories ", sentiment: "0.1", emotion: "happy", relations: "relations", roles: "roles"),
        News(newsId: "4", title: "title 4", concepts: "concepts", keywords: "keywords, keywords ", entities: "entities, entities ", categories: "categories ", sentiment: "0.1", emotion: "happy", relations: "relations", roles: "roles")
    ]
    
    override func viewDidLoad() {
        NSLog("view did load")

        let creds = WhiskCredentials(accessKey: WhiskAppKey,accessToken: WhiskAppSecret)
        let whisk = Whisk(credentials: creds)
        
        //call Serverless sequence1
        NSLog("calling Serverless sequence 1")
        let params0 = Dictionary<String, String>()
        do {
         try whisk.invokeAction(name: MyWhiskAction0, package: MyPackage, namespace: MyNamespace, parameters: params0 as AnyObject, hasResult: HasResult, callback: {(reply, error) -> Void in
             if let error = error {
                 //do something
                 print("Error invoking action \(error.localizedDescription)")
             } else {
                 print("Action invoked!")
             }

        })
        } catch {
                   print("Error \(error)")
        }

        NSLog("calling Action 2 - all the Ids ")
        
        var params = Dictionary<String, String>()
        //params["payload"] = "Hi from mobile"

        do {
            try whisk.invokeAction(name: MyWhiskAction1, package: MyPackage, namespace: MyNamespace, parameters: params as AnyObject, hasResult: HasResult, callback: {(reply, error) -> Void in
                if let error = error {
                    //do something
                    print("Error invoking action \(error.localizedDescription)")
                } else {
                    print("Action invoked!")
                    var insertedHNewsIdRecords = 0
                    var result = (reply?["result"]?["newsIds"]) as! Array<Int64?>
                    //let shortarray = result[0..<5]
                    let shortarray = result[0..<100]
                    for newsIdoptional in shortarray {
                        let newsId: Int64 = newsIdoptional ?? 0
                        print("\(newsId), \(insertedHNewsIdRecords)")
                        insertedHNewsIdRecords = insertedHNewsIdRecords+1
                        
                        let whisk2 = Whisk(credentials: creds)
                        
                        //go through the array
                        //call NLUAction to get the details
                        var nluParameters = Dictionary<String, String>()
                        nluParameters["newsIds"] = String(newsId)
                        NSLog("calling NLU Action with the ID \(newsId)")
                        do {
                            try whisk2.invokeAction(name: self.MyWhiskAction2, package: self.MyPackage, namespace: self.MyNamespace, parameters: nluParameters as AnyObject, hasResult: self.HasResult, callback: {(reply, error) -> Void in
                                if let error = error {
                                    //do something
                                    print("Error invoking action \(error.localizedDescription)")
                                } else {
                                    print("Action invoked!")
                                    print("Got result \(reply?["result"]?["NLUProcessedHNewsJSON"])")
                                    
                                    let arrayNLU = reply?["result"]?["NLUProcessedHNewsJSON"] as! Array<Any>
                                    
                                    if arrayNLU.count>0{
                                        print("array\(arrayNLU[0])")
                                        let myMutableDict = arrayNLU[0] as? NSMutableDictionary ?? nil
                                        if myMutableDict != nil {
                                            // categories
                                            var categories = "categories: "
                                            let categoriesString = myMutableDict!["categories"] as! String
                                            //parsing for the text with \"
                                            let arrayEvenCategories = categoriesString.components(separatedBy: "\"")
                                            print(arrayEvenCategories)
                                            var i = 1
                                            for item in arrayEvenCategories {
                                                if (i % 2 == 0) {
                                                    categories = categories + "\(item ), "
                                                }
                                                i+=1
                                            }
                                            
                                            // concepts
                                            var concepts = "concepts: "
                                            let conceptsStrings  = myMutableDict!["concepts"]
                                                as! String
                                                //parsing for the text with \"
                                                let arrayEvenConcepts = conceptsStrings.components(separatedBy: "\"")
                                                print(arrayEvenConcepts)
                                                i = 1
                                                for item in arrayEvenConcepts {
                                                    if (i % 2 == 0) {
                                                        concepts = concepts + "\(item),  "
                                                    }
                                                    i+=1
                                                }
                                            
                                            // entities
                                            var entities = "entities: "
                                            let entitiesString = myMutableDict!["entities"] as! String
                                            //parsing for the text with \"
                                            let arrayEvenEntities = entitiesString.components(separatedBy: "\"")
                                            print(arrayEvenEntities)
                                            i = 1
                                            for item in arrayEvenEntities {
                                                if (i % 2 == 0) {
                                                    entities = entities + "\(item),  "
                                                }
                                                i+=1
                                            }
                                            
                                            // keywords
                                            var keywords = "keywords: "
                                            let keywordString = myMutableDict!["keywords"] as! String
                                            //parsing for the text with \"
                                            let arrayEvenKeywords = keywordString.components(separatedBy: "\"")
                                            print(arrayEvenKeywords)
                                            i = 1
                                            for item in arrayEvenKeywords {
                                                if (i % 2 == 0) {
                                                    keywords = keywords + "\(item),  "
                                                }
                                                i+=1
                                            }
                                           
                                            let newsIdNLU = myMutableDict!["newsid"] ?? ""
                                            let titleNLU = myMutableDict!["title"]  ?? ""
                                            print("catergories \(categories)")
                                            print("concepts \(concepts)")
                                            print("entities \(entities)")
                                            
                                            print("title \(String(describing: titleNLU))")
                                            print("id \(newsIdNLU)")
                                            
                                            self.hackerNews.append(
                                                News(newsId: newsIdNLU as! String, title: titleNLU as! String, concepts: concepts as! String, keywords: keywords as! String, entities: entities as! String, categories: categories as! String, sentiment: "", emotion: "", relations: "", roles: ""))
                                        }
                                    }
                                }

                            })
                            } catch {
                                print("Error in NLU \(error)")
                            }
                    }
                    print("Got result \(insertedHNewsIdRecords)")
                }

            })
        } catch {
            print("Error in HN API \(error)")
        }
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(cleanArray), for: .valueChanged)
        self.refreshControl = refreshControl
        navigationItem.title = "Serverless Swift - Hacker News with NLU"
        
        //go through the array
        //call NLUAction to get the details
        NSLog("calling NLU Action with the ID 1")
        
        NSLog("ready!")
        
    }
  
    @objc func cleanArray() {
            
        //remove initial 4 cells
        if self.isInitial {
            self.isInitial=false
            NSLog(String(hackerNews.count))
            hackerNews.removeFirst()
            hackerNews.removeFirst()
            hackerNews.removeFirst()
            hackerNews.removeFirst()
            NSLog(String(hackerNews.count))
        }
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
  
    // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("checking no of rows")
        
        // #warning Changes return the number of rows
        return hackerNews.count
    }

    // changes for H-News
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("creating a cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)

        // Configure the cell...
        let hackerNewsSingle = hackerNews[indexPath.row]
        cell.textLabel?.text = hackerNewsSingle.title
        cell.detailTextLabel?.text = "\(hackerNewsSingle.keywords) | \(hackerNewsSingle.entities) | \(hackerNewsSingle.categories) | \(hackerNewsSingle.concepts)"
        //NSLog("keywords \(hackerNewsSingle.keywords)")
        return cell
    }
    
}

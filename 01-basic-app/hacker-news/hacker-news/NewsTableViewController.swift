//
//  NewsTableViewController.swift
//  hacker-news
//
//  Created by Marek Sadowski on 5/28/20.
//  Copyright © 2020 Serverless Swift. All rights reserved.
//

import UIKit

// changes for H-News
struct News {
    var newsId: String
    var title: String
    
    // data from Watson NLU: concepts, entities, keywords, categories, sentiment, emotion, relations, semantic roles
    var concepts : String
    var keywords : String
    var entities : String
    var categories : String
    var sentiment : String
    var emotion : String
    var relations : String
    var roles : String
}

class NewsTableViewController: UITableViewController {
    
    let hackerNews = [
        News(newsId: "1", title: "title 1", concepts: "concepts", keywords: "keywords, keywords", entities: "entities, entities", categories: "categories", sentiment: "0.1", emotion: "happy", relations: "relations", roles: "roles"),
        News(newsId: "2", title: "title 2", concepts: "concepts", keywords: "keywords, keywords", entities: "entities, entities", categories: "categories", sentiment: "0.1", emotion: "happy", relations: "relations", roles: "roles"),
        News(newsId: "3", title: "title 3", concepts: "concepts", keywords: "keywords, keywords", entities: "entities, entities", categories: "categories", sentiment: "0.1", emotion: "happy", relations: "relations", roles: "roles"),
        News(newsId: "4", title: "title 4", concepts: "concepts", keywords: "keywords, keywords", entities: "entities, entities", categories: "categories", sentiment: "0.1", emotion: "happy", relations: "relations", roles: "roles")
]
    
    
    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Changes: return the number of sections (happy, none, sad)
        return 1
    }
     */

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Changes return the number of rows
        return hackerNews.count
    }

    // changes for H-News
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)

        // Configure the cell...
        let hackerNewsSingle = hackerNews[indexPath.row]
        cell.textLabel?.text = hackerNewsSingle.title
        cell.detailTextLabel?.text = "\(hackerNewsSingle.keywords) |  \(hackerNewsSingle.entities) | \(hackerNewsSingle.categories) "

        return cell
    }
    
    // changes for H-News
    /*override  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
     */
}

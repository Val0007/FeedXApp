//
//  Networking.swift
//  Rss Reader
//
//  Created by Val V on 20/09/22.
//

import Foundation
import UIKit

struct feedItem{
    let feedItemTitle:String
    let feedItemLink:String
    let feedItemDesc:String
    let feedItemDate:String
    var feedPublisher:String = ""
    var folder:String = ""
}

//enter into channel
//if channel has title grab title and save
//after all items channel ends
//insert channel name to all items


class Networking:NSObject,XMLParserDelegate{

    let recordKey = "item"
    let dictionaryKeys = Set<String>(["title", "link", "description","pubDate"])
    var isInRecord:Bool = false
    var channelKey = "title"
    var channelName = ""
    var isInTitle:Bool = false

    // a few variables to hold the results as we parse the XML

    var results: [feedItem] = []         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var cv:String = ""
    
    func getData(urlP:String,pubL:String,completion:@escaping([feedItem])->()){
        let urll = urlP.replacingOccurrences(of: "\\s+", with: "", options: .regularExpression, range: nil)
        guard let url = URL(string: urll) else {return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }

            let parser = XMLParser(data: data)
            parser.delegate = self
            if parser.parse() {
                for (index,_) in self.results.enumerated() {
                    self.results[index].feedPublisher = pubL
                }
                for result in self.results{
                    print(result)
                }
                completion(self.results)
            }
        }
        task.resume()
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        results = []
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == recordKey {
            isInRecord = true
            currentDictionary = [:]
        }
        else if elementName == "channel"{
            isInRecord = false
            isInTitle = true
        }
        else if dictionaryKeys.contains(elementName) {
            self.cv = ""
        }

    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if isInRecord{
            self.cv.append(string)
        }
        else if isInTitle{
            channelName.append(string)
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print(elementName)
        if elementName == recordKey {
            isInRecord = false
            let f = feedItem(feedItemTitle: currentDictionary?["title"] ?? "", feedItemLink: currentDictionary?["link"] ?? "", feedItemDesc: currentDictionary?["description"] ?? "",feedItemDate: currentDictionary?["pubDate"] ?? "")
            results.append(f)
            currentDictionary = nil
        } else if dictionaryKeys.contains(elementName) && !isInTitle{
            currentDictionary?[elementName] = self.cv
            self.cv = ""
        }
        else if elementName == "title"{
            isInTitle = false
            print("Print Title of RSS")
            print(channelName)
        }
    }

    // Just in case, if there's an error, report it. (We don't want to fly blind here.)

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
        cv = ""
        currentDictionary = nil
        results = []
    }

}
    

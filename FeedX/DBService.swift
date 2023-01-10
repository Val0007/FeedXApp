//
//  CoreDataService.swift
//  FeedX
//
//  Created by Val V on 26/11/22.
//

import Foundation
import SQLite

class SqlDB{
    
    var database:Connection?
    
    init(){
        createConnection()
        if(isTableCreated){
            print("Table already exists")
        }
        else{
            createTable()
        }
    }
    
    var isTableCreated:Bool{
        do{
            let st =  try database!.prepare("SELECT name FROM sqlite_master WHERE type = 'table'")
            for i in try st.run(){
                let arr = i as! [String]
                if arr[0] == "Articles"{
                    return true
                }
            }
            
        }
        catch{
            return false
        }
        return false
    }
    
    func createConnection(){
        do {
            //folder for app
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            
            let fileUrl = documentDirectory.appendingPathComponent("db").appendingPathExtension("sqlite3")
            
            let database = try Connection(fileUrl.path)
            self.database = database
            print("connection established")
        } catch {
            print(error)
        }
    }
    
    
    func createTable(){
        let usertable = Table("Articles")
        let Title = Expression<String>("Title")
        let Link = Expression<String>("Link")
        let Desc = Expression<String>("Desc")
        let Date = Expression<String>("Date")
        let Publisher = Expression<String>("Publisher")
        let folder = Expression<String>("folder")

        let createTable = usertable.create { (table) in
            table.column(Title)
            table.column(Link)
            table.column(Desc)
            table.column(Date)
            table.column(Publisher)
            table.column(folder)

        }
        
        do {
            guard let con = database else {return}
            try con.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
    }
    
    func dropTable(){
        do{
           let st =  try database!.prepare("DROP TABLE ARTICLES")
            try st.run()
        }
        catch{
            print(error)
        }
    }
    
    func insertArticle(){
        do{
            guard let db = database else {return}
            var q = try db.prepare("INSERT INTO ARTICLES VALUES (?,?,?,?,?,?)")
            let values = ["ddd","ddd","ddd","fff","fff","ggg"]
            try q.run(values[0],values[1],values[2],values[3],values[4],values[5])
            q = try db.prepare("Select * from articles")
            for row in q{
                let item = makeStruct(folder: "motorsport", row: row)
                print(item)
            }
        }
        catch{
            print(error)
            print("EE")
        }
    }
    
    func makeStruct(folder:String,row:Array<Optional<Binding>>)->feedItem{
        let title = row[0] as? String
        let link = row[1] as? String
        let desc = row[2] as? String
        let date = row[3] as? String
        let pub = row[4] as? String

        return feedItem(feedItemTitle: title ?? "",feedItemLink: link ?? "", feedItemDesc: desc ?? "",feedItemDate: date ?? "",feedPublisher: pub ?? "",folder: folder)
    }
    
}

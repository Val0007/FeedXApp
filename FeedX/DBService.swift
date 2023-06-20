//
//  CoreDataService.swift
//  FeedX
//
//  Created by Val V on 26/11/22.
//

import Foundation
import SQLite

enum articleType:String{
    case fav = "favourite"
    case readlater = "readlater"
}

enum InsertType{
    case Article(String,String,String,String,String,String,articleType)//tit,link,desc,date,pub,folder
    case Folders(String) //folder
    case Link(String,String,String) //folder,publisher,url
}

struct urlReturnType{
    let url:String
    let publisher:String
}


class SqlDB{
    
    var database:Connection?
    static let shared = SqlDB()
    

    


    // MARK: RETREIVAL
    func getArticles(type:articleType)->[feedItem]{
        guard let db  = SqlDB.shared.database else {return []}
        do{
            var articles:[feedItem] = []
            let q = try db.prepare("Select * from ARTICLES where type = ?")
            let values = [type.rawValue]
            let results = try q.run(values[0])
                for row in results{
                    if let r = row as? [String]{
                        if !r.isEmpty{
                            articles.append(makeStruct(row: r))
                        }
                    }
                }
            return articles
        }
        catch{
            return []
        }
    }
    
    func getFolders()->[String]{
        guard let db  = SqlDB.shared.database else {return []}
        do{
            let q = try db.prepare("Select * from Folders")
            let results = try q.run()
            var folders :[String] = []
            for row in results{
                if let r = row as? [String]{
                    print(r)
                    if !r.isEmpty{
                        folders.append(r[0])
                    }
                }
            }
            return folders
        }
        catch{
            return []
        }
    }
    
    func getURLS(foldername:String)->[urlReturnType]{
        guard let db  = SqlDB.shared.database else {return []}
        do{
            let q = try db.prepare("Select * from link where folder = ?")
            let results = try q.run(foldername)
            var urls :[urlReturnType] = []
            for row in results{
                print(row)
                if let r = row as? [String]{
                    print(r)
                    if !r.isEmpty{
                        let u = urlReturnType(url: r[2], publisher: r[1])
                        urls.append(u)
                    }
                }
            }
            return urls
        }
        catch{
            return []
        }
    }
    
    func getPublishers(foldername:String) -> [String]{
        guard let db  = SqlDB.shared.database else {return []}
        do{
            let q = try db.prepare("Select * from link where folder = ?")
            let results = try q.run(foldername)
            var pubs :[String] = []
            for row in results{
                print(row)
                if let r = row as? [String]{
                    print(r)
                    if !r.isEmpty{
                        pubs.append(r[1])
                    }
                }
            }
            return pubs
        }
        catch{
            return []
        }
    }

    func folderExists()->Bool{
        return false
    }
    
    
    
    // MARK: INSERTION
    
    func insertElement(type:InsertType,completion:(Bool)->()){
        
        do{
            guard let db = SqlDB.shared.database else {return}
            
            switch type {
            case .Article(let title, let link, let desc, let date, let pub, let folder,let atype):
                //check if article exists
                    let q = try db.prepare("SELECT EXISTS(SELECT * FROM ARTICLES WHERE link = (?) and type = (?))")
                    let values = [link,atype.rawValue]
                    let result = try q.run(values[0],values[1])
                    for row in result{
                        print(row)
                        let intArray = row.map { $0 as? Int64 }
                        print(intArray)
                            if intArray[0] == 0 { //doesnt exist
                                let q = try db.prepare("INSERT INTO ARTICLES VALUES (?,?,?,?,?,?,?)")
                                let values = [title,link,desc,date,pub,folder,atype.rawValue]
                                try q.run(values[0],values[1],values[2],values[3],values[4],values[5],values[6])
                                completion(true)
                            }
                            else{
                                print("Exists in db")
                                completion(false)
                            }
                        }

                
            case .Folders(let folder):
                //check if folder exists
                let q = try db.prepare("INSERT INTO Folders VALUES (?)")
                let values = [folder]
                try q.run(values[0])
                completion(true)
                
            case .Link(let folder, let publisher, let url):
                    //check if link already exists
                let q = try db.prepare("INSERT INTO Link VALUES (?,?,?)")
                let values = [folder,publisher,url]
                try q.run(values[0],values[1],values[2])
                completion(true)
                
            }
        }
        catch{
            print(error)
            print("ERROR DURING INSERTION")
            completion(false)
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
    
    func makeStruct(row:[String])->feedItem{
            let title = row[0]
            let link = row[1]
            let desc = row[2]
            let date = row[3]
            let pub = row[4]
            let folder = row[5]
            
            let item =  feedItem(feedItemTitle: title,feedItemLink: link , feedItemDesc: desc ,feedItemDate: date ,feedPublisher: pub,folder: folder)
           return item
    
    }
    
    
    // MARK: CREATING TABLES
    
    func createTable(){
        let usertable = Table("Articles")
        let Title = Expression<String>("Title")
        let Link = Expression<String>("Link")
        let Desc = Expression<String>("Desc")
        let Date = Expression<String>("Date")
        let Publisher = Expression<String>("Publisher")
        let folder = Expression<String>("folder")
        let type = Expression<String>("type")

        let createTable = usertable.create { (table) in
            table.column(Title)
            table.column(Link)
            table.column(Desc)
            table.column(Date)
            table.column(Publisher)
            table.column(folder)
            table.column(type)
        }
        
        do {
            guard let con = self.database else {return}
            try con.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
        
        
        
    }
    
    func createLinksTable(){
        print("CREATING LINK")
        let usertable = Table("Link")
        let folder = Expression<String>("folder")
        let publisher = Expression<String>("publisher")
        let url = Expression<String>("url")
        let createTable = usertable.create { (table) in
            table.column(folder)
            table.column(publisher)
            table.column(url)
        }
    
        do {
            guard let con = self.database else {return}
            try con.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }

    }
    
    
    
    
    func createFoldersTable(){
        print("CREATING FOLDER")
        let usertable = Table("Folders")
        let folder = Expression<String>("folder")
        let createTable = usertable.create { (table) in
            table.column(folder)
        }
        
        do {
            guard let con = self.database else {return}
            try con.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }

    }
    
    var isTableCreated:Bool{
        do{
            let st =  try self.database!.prepare("SELECT name FROM sqlite_master WHERE type = 'table'")
            var tables :[String] = []
            for k in try st.run(){
                if let name = k as? [String]{
                    tables.append(name[0])
                }
            }
                if tables.contains("Articles"){
                    if tables.contains("Folders"){
                        if tables.contains("Link"){
                            return true
                        }
                        else{
                            return false
                        }
                    }
                    else{
                        return false
                    }
                }
                else{
                    return false
                }
                
            }
        catch{
            return false
        }
        
    }
    
    
    // MARK: CONNECTION
    func createConnection(){
        do {
            //folder for app
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            print(documentDirectory)
            let fileUrl = documentDirectory.appendingPathComponent("db").appendingPathExtension("sqlite3")
            
            let database = try Connection(fileUrl.path)
            self.database = database
            print("connection established")
        } catch {
            print(error)
        }
    }
    
    
    // MARK: INIT
    
    init(){
        createConnection()
        if(isTableCreated){
            print("Table already exists")
        }
        else{
            print("CREATING")
            createFoldersTable()
            createLinksTable()
            createTable()
        }
    }

    
    // MARK: DELETION
    
    
    func dropTable(){
        do{
           let st =  try SqlDB.shared.database!.prepare("DROP TABLE ARTICLES")
            try st.run()
        }
        catch{
            print(error)
        }
    }
    
    
    func deleteURL(url:String)->Bool{
        do{
            guard let db = SqlDB.shared.database else {return false}
            
            let q = try db.prepare("DELETE FROM LINK WHERE URL = (?)")
            let values = [url]
            try q.run(values)
            return true
            
        }
        catch{
            print(error)
            return false
        }
    }
    
    func deleteArticle(url:String,atype:articleType)->Bool{
        guard let db = SqlDB.shared.database else {return false}
        do{
            
        let q = try db.prepare("DELETE FROM ARTICLES WHERE LINK = (?) and type = ?")
        let values = [url,atype.rawValue]
        try q.run(values)
        return true
    }
    catch{
        print(error)
        return false
    }
    }
    
}

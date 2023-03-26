//
//  DeleteURLVC.swift
//  FeedX
//
//  Created by Val V on 17/03/23.
//

import UIKit

class DeleteURLVC: UIViewController {
    
    let tv = UITableView()
    var folders:[String] = []
    var cellData = SwiftyAccordionCells()
    var previouslySelectedHeaderIndex: Int?
    var selectedHeaderIndex: Int?
    var selectedItemIndex: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
        style()
        makeTV()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Delete URL"
    }
    

    private func setup(){
        view.addSubview(tv)
        tv.addConstraintsToFillView(view)
        tv.dataSource = self
        tv.delegate = self
        
    }
    
    private func layout(){
        
    }
    
    private func style(){
        view.backgroundColor = .white
    }
    
    private func makeTV(){
        let headers = SqlDB.shared.getFolders()
        self.folders = headers
        makeData()
        
    }
    
    private func makeData(){
        for header in folders{
            cellData.append(SwiftyAccordionCells.HeaderItem(value: header))
            let urls = SqlDB.shared.getURLS(foldername: header)
            for url in urls{
                cellData.append(SwiftyAccordionCells.Item(value: url.url,pub: url.publisher))
            }
        }
        
        self.tv.reloadData()
    }

}


extension DeleteURLVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = cellData.items[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = data.value
        cell.textLabel?.textColor = .black
        cell.textLabel?.numberOfLines = 0
        
        if data as? SwiftyAccordionCells.HeaderItem != nil {
            cell.backgroundColor = UIColor.lightGray
            cell.accessoryType = .none
        }
        else{
            cell.textLabel?.text = "\(data.value) - \(data.pub)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let celltype = cellData.items[indexPath.row]
        if celltype is SwiftyAccordionCells.HeaderItem{
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle  == .delete{
            let url = cellData.items[indexPath.row]
            if SqlDB.shared.deleteURL(url: url.value){
                print("Deleted successfully")
            }
            //remove cell
            cellData.items.remove(at: indexPath.row)
            tv.deleteRows(at: [indexPath], with: .top)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.cellData.items[(indexPath as NSIndexPath).row]
        for cell in cellData.items{
            print(cell.value)
            print(cell.isHidden)
        }
        if item is SwiftyAccordionCells.HeaderItem {
            return self.view.frame.height * 0.08
        }
        else if (item.isHidden) {
            return 0
        }
        else {
            print("YES")
            return self.view.frame.height * 0.08
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.cellData.items[(indexPath as NSIndexPath).row]
        
        if item is SwiftyAccordionCells.HeaderItem {
            if self.selectedHeaderIndex == nil {
                self.selectedHeaderIndex = (indexPath as NSIndexPath).row
            } else {
                self.previouslySelectedHeaderIndex = self.selectedHeaderIndex
                self.selectedHeaderIndex = (indexPath as NSIndexPath).row
            }
            
            if let previouslySelectedHeaderIndex = self.previouslySelectedHeaderIndex {
                self.cellData.collapse(previouslySelectedHeaderIndex)
            }
            
            if self.previouslySelectedHeaderIndex != self.selectedHeaderIndex {
                self.cellData.expand(self.selectedHeaderIndex!)
            } else {
                self.selectedHeaderIndex = nil
                self.previouslySelectedHeaderIndex = nil
            }
            self.tv.beginUpdates()
            self.tv.endUpdates()
            
        }
    }
    
}

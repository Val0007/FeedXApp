//
//  DisplaySavedVC.swift
//  FeedX
//
//  Created by Val V on 26/03/23.
//

import UIKit



class DisplaySavedVC: UIViewController {
    
    let atype:articleType
    var items:[feedItem] = []
    let db = SqlDB.shared
    let tv = UITableView()
    
    init(t:articleType) {
        self.atype = t
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        switch atype {
        case .fav:
            self.title = "Favourites"
        case .readlater:
            self.title = "Read Later"
        }
    }
    
    private func loadData(){
        switch atype {
        case .fav:
            items = db.getArticles(type: .fav)
            DispatchQueue.main.async {
                self.tv.reloadData()
            }
        case .readlater:
            items = db.getArticles(type: .readlater)
            DispatchQueue.main.async {
                self.tv.reloadData()
            }
        }
    }
    
    private func setup(){
        view.addSubview(tv)
        tv.addConstraintsToFillView(view)
        tv.delegate = self
        tv.dataSource = self
//        tv.register(urlCell.self, forCellReuseIdentifier: urlCell.identifier)
        tv.register(articleCell.self, forCellReuseIdentifier: "articleCell")
        tv.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 1.00, alpha: 1.00)
        tv.separatorStyle = .none
    }
    

}

extension DisplaySavedVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! articleCell
        let item = items[indexPath.row]
        cell.update(item: item)
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 0.85, green: 0.89, blue: 0.89, alpha: 1.00)
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.height * 0.20
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let wk = WebViewController(u: item.feedItemLink)
        self.navigationController?.pushViewController(wk, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        
        let rightAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let article = self.items[indexPath.row]
            let r = self.db.deleteArticle(url: article.feedItemLink, atype: self.atype)
            if(r){
                print("DELETED")
            }
            else{
                print("ERRRO")
            }
            success(true)
        })

        rightAction.image = UIImage(systemName: "trash.fill")
        rightAction.backgroundColor = UIColor.systemRed

        return UISwipeActionsConfiguration(actions: [rightAction])
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {

           if let cell = tableView.cellForRow(at: indexPath) as? urlCell{
               let fr = cell.getFrame()
               if let spvcell = cell.superview{
                   for svswipe in spvcell.subviews{
                       let typeview = type(of: svswipe.self)
                       if typeview.description() == "UISwipeActionPullView"{
                           svswipe.frame.size.height = fr.height//size you want
                           svswipe.frame.origin.y = fr.origin.y
                       }
                   }
               }
           }
       }

}

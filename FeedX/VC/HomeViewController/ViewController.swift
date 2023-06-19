//
//  ViewController.swift
//  FeedX
//
//  Created by Val V on 05/10/22.
//

import UIKit
import SnapKit


class ViewController: UIViewController {
    
    //var folderBar:FolderBar?
    let tableView = UITableView()
    var st:SlideInPresentationManager?
    let db = SqlDB.shared
    var items:[feedItem] = []
    let tabBT = TabBt() //bottom tab bar
    let cv = UICollectionView(frame: .zero, collectionViewLayout: createHorizontalFlowLayout())
    var selectedIndex = 0
    var folderNames:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        //let folders = db.getFolders()
        //folderBar = FolderBar(frame: .zero, f: folders)
        
        setup()
        layout()
        style()
        NotificationManager().status()
        UIApplication.shared.isStatusBarHidden=true; // for status bar hide
        folderNames = db.getFolders()
        if(!folderNames.isEmpty){
            fetchData(folderName: folderNames[0])
        }
        cv.reloadData()
        tableView.reloadData()
//        db.dropTable()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setup(){
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
//        guard let folderBar = folderBar else {
//            return
//        }
//        folderBar.delegate = self
//        view.addSubview(folderBar)
        
        
//        view.addSubview(tb)
//        tb.delegate = self
        
        
        //collectionview
        view.addSubview(cv)
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(folderNameCell.self, forCellWithReuseIdentifier: "foldercollCell")
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(urlCell.self, forCellReuseIdentifier: urlCell.identifier)

        view.addSubview(tabBT)
        tabBT.delegate = self

        
        print(view.subviews)

    }
    
    private func layout(){
//        guard let folderBar = folderBar else {
//            return
//        }

//        folderBar.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.safeAreaLayoutGuide.leftAnchor,right: view.safeAreaLayoutGuide.rightAnchor,height: view.frame.height * 0.08)
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cv.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive  = true
        cv.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true

        
        tableView.anchor(top: cv.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
    }
    
    private func style(){
        tableView.separatorStyle = .none
        tabBT.centerX(inView: view)
        tabBT.anchor(bottom:view.bottomAnchor,paddingBottom: 60,width: view.frame.width * 0.40,height: view.frame.height * 0.05)
    }
    
    private func fetchData(folderName:String){
        print("FETCHING DATA")
        let resutls = SqlDB.shared.getURLS(foldername: folderName)
        print(resutls)
        let myGroup = DispatchGroup()

        for r in resutls{
            myGroup.enter()
            Networking().getData(urlP:r.url , pubL: r.publisher, completion: { resultitems in
                self.items.append(contentsOf: resultitems)
                myGroup.leave()
            })
        }
        
        myGroup.notify(queue: .main){
            print("COMPLETED")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    private func presentSideVC(){
        //FLOW-> present() or dismiss() -> presentationManager -> presentationAnimator animates -> presentationController
        let slie = SideVC()
        slie.delegate = self
        st = SlideInPresentationManager()
        st?.direction = .right
        slie.transitioningDelegate = st
        slie.modalPresentationStyle = .custom
        present(slie, animated: true, completion: nil)
    }

    
    private func changeNavigationAppearance(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.green // your colour here

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // This will alter the navigation bar title appearance
        let titleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.purple] //alter to fit your needs
        appearance.titleTextAttributes = titleAttribute
    }
    

    


}


extension ViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: urlCell.identifier, for: indexPath) as! urlCell
        let item = items[indexPath.row]
        cell.makeCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.height * 0.11
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let wk = WebViewController(u: item.feedItemLink)
        self.navigationController?.pushViewController(wk, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let leftAction = UIContextualAction(style: .normal, title:  "Favourite", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                let article = self.items[indexPath.row]
                self.db.insertElement(type: .Article(article.feedItemTitle, article.feedItemLink, article.feedItemDesc, article.feedItemDate, article.feedPublisher, article.folder,.fav)) { comp in
                    
                    if comp{
                        print("INSERTED")
                    }
                    else{
                        print("EXISTS")
                    }
                }
                success(true)
            })

            leftAction.image = UIImage(systemName: "suit.heart.fill")
        leftAction.backgroundColor = UIColor.twitterBlue
        


            return UISwipeActionsConfiguration(actions: [leftAction])
        }

        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
            
            let rightAction = UIContextualAction(style: .normal, title:  "Read Later", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                let article = self.items[indexPath.row]
                self.db.insertElement(type: .Article(article.feedItemTitle, article.feedItemLink, article.feedItemDesc, article.feedItemDate, article.feedPublisher,self.folderNames[self.selectedIndex],.readlater)) { comp in
                    
                    if comp{
                        print("INSERTED")
                    }
                    else{
                        print("EXISTS")
                    }
                }
                success(true)
            })

            rightAction.image = UIImage(systemName: "bag.fill")
            rightAction.backgroundColor = UIColor.link

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


extension ViewController:tabButtonClick{
    func changePage(page: page) {
        switch page {
        case .Home:
            return
        case .Options:
            presentSideVC()
        }
    }
}

extension ViewController:SideVCPush{
    func pushVC(type:types) {
        switch type {
        case .anf:
            self.navigationController?.pushViewController(AddFolderVC(), animated: true)
        case .anu:
            self.navigationController?.pushViewController(AddURLVC(), animated: true)
        case .df:
            return
        case .du:
            self.navigationController?.pushViewController(DeleteURLVC(), animated: true)
            return
        case .f:
            self.navigationController?.pushViewController(DisplaySavedVC(t: .fav), animated: true)
            return
        case .rl:
            self.navigationController?.pushViewController(DisplaySavedVC(t: .readlater), animated: true)
            return
        }
    }
    
    func willpop() {
        tabBT.handleHome()
    }
}

extension ViewController:FolderBarDelegate{
    func switchFolder(folder: String) {
        self.items = []
        fetchData(folderName: folder)
    }
    
    

}

extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folderNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "foldercollCell", for: indexPath) as! folderNameCell
        cell.update(label: folderNames[indexPath.row])
        if selectedIndex == indexPath.row{
            cell.toggle(value:true)
        }
        else{
            cell.toggle(value: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let oldCell = cv.cellForItem(at: IndexPath(row: selectedIndex, section: 0)) as! folderNameCell
        oldCell.toggle(value: false)
        selectedIndex = indexPath.row
        let newCell = cv.cellForItem(at: IndexPath(row: selectedIndex, section: 0)) as! folderNameCell
        newCell.toggle(value: true)
        switchFolder(folder: folderNames[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.width
        let cellWidth = screenWidth / 4 // Divide the screen width by the number of cells you want in a row
        let cellHeight: CGFloat = collectionView.bounds.height * 0.8 // Set the height to your desired value
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 8, bottom: 5, right: 8)
        }
    
    
}



func createHorizontalFlowLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    return layout
}

//
//  ViewController.swift
//  FeedX
//
//  Created by Val V on 05/10/22.
//

import UIKit
import SnapKit


class ViewController: UIViewController{
    
    
    //var folderBar:FolderBar?
    let tableView = UITableView()
    var st:SlideInPresentationManager?
    let db = SqlDB.shared
    var items:[feedItem] = []
    var parentCopyItems:[feedItem] = []
    let tabBT = TabBt() //bottom tab bar
    let cv = UICollectionView(frame: .zero, collectionViewLayout: createHorizontalFlowLayout())
    var selectedIndex = 0
    var folderNames:[String] = []
    let bottomBar = BottomBar()
    var selectedRowIndex:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        style()
        NotificationManager().status()
        UIApplication.shared.isStatusBarHidden=true; // for status bar hide
        loadFolderView()
        if(!folderNames.isEmpty){
            fetchData(folderName: folderNames[0])
        }
        tableView.reloadData()
//        db.dropTable()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func loadFolderView(){
        folderNames = db.getFolders()
        print("folders are ",folderNames)
        cv.reloadData()
    }
    
    private func setup(){
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
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
        tableView.register(articleCell.self, forCellReuseIdentifier: "articleCell")

        if !(folderNames == []){
        //To create filter options
        bottomBar.pubNames = db.getPublishers(foldername: folderNames[selectedIndex])
        bottomBar.changeMenu()
        }
        view.addSubview(bottomBar)
        bottomBar.delegate = self
        
        
    }
    
    private func layout(){

        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cv.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive  = true
        cv.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true

        
        tableView.anchor(top: cv.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
        
        bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        bottomBar.centerX(inView: view)
        bottomBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        bottomBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true

    }
    
    private func style(){
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 1.00, alpha: 1.00)
        
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
                self.parentCopyItems = self.items
                
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
        if folderNames.count == 0{
            self.tableView.setEmptyMessage("Add a folder to add feed Links")
        }
        else{
            if items.count == 0 {  //a folder exits
                self.tableView.setEmptyMessage("Add RSS feed links to see Feed")
            }
            else{
                self.tableView.restore()
            }
        }
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
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        selectedRowIndex = indexPath.row
        let wk = WebViewController(u: item.feedItemLink)
        wk.delegate = self
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
    
    func pubFilter(pubName: String) {
        items = parentCopyItems.filter { $0.feedPublisher == pubName }
        tableView.reloadData()
    }
    
    func pubAll() {
        items = parentCopyItems
        tableView.reloadData()
    }
}

extension ViewController:SideVCPush{
    func pushVC(type:types) {
        switch type {
        case .anf:
            let addvc = AddFolderVC()
            addvc.delegate = self
            self.navigationController?.pushViewController(addvc, animated: true)
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
//        tabBT.handleHome()
        bottomBar.handleHome()
    }
}

extension ViewController:FolderBarDelegate{
    func switchFolder(folder: String) {
        self.items = []
        self.parentCopyItems = []
        fetchData(folderName: folder)
        bottomBar.pubNames = db.getPublishers(foldername: folderNames[selectedIndex])
        bottomBar.changeMenu()

    }
    
}

extension ViewController:webVCdelegate{
    func getNextArticle() -> feedItem? {
        if let index = selectedRowIndex{
            if(items.indices.contains(index + 1)){
                return items[index + 1]
            }
        }
        else{
            print("whhh")
        }
        return nil
    }
    
    func changeSelectedIndex() {
        selectedRowIndex! += 1
    }
}

extension ViewController:AddDelegate{
    func refreshFolder() {
        loadFolderView()
        selectedIndex = folderNames.count - 1
        switchFolder(folder: folderNames[selectedIndex])
    }
    func refreshUrlFeed() {
        
    }
}

extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if folderNames.count == 0{
            self.setEmptyMessage("Add New Folders To See them here")
        }
        else{
            self.restore()
        }
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
    
    
    func setEmptyMessage(_ message: String) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        let bt = UIButton()
        bt.setTitle("Add Folder", for: .normal)
        bt.backgroundColor = .link
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cv.bounds.size.width, height: cv.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        messageLabel.sizeToFit()

        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(bt)
        stackView.alignment = .center
        stackView.spacing  = 5
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.3).isActive = true
        bt.layer.cornerRadius = 5
        bt.setTitleColor(.white, for: .normal)
        bt.addTarget(self, action: #selector(handleAddFolder), for: .touchUpInside)
        cv.backgroundView = stackView
    }

    func restore() {
        cv.backgroundView = nil
    }
    
    @objc func handleAddFolder(){
        let addvc = AddFolderVC()
        addvc.delegate = self
        self.navigationController?.pushViewController(addvc, animated: true)
    }
    
}



func createHorizontalFlowLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    return layout
}


extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}

extension UICollectionView {


}

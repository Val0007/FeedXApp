//
//  ViewController.swift
//  FeedX
//
//  Created by Val V on 05/10/22.
//

import UIKit


class ViewController: UIViewController {
    
    var folderBar:FolderBar?
    let tableView = UITableView()
    let feedArray :[feedItem] = []
    var st:SlideInPresentationManager?
    let tb = TabButtons()
    let db = SqlDB.shared
    var items:[feedItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let folders = db.getFolders()
        folderBar = FolderBar(frame: .zero, f: folders)
        setup()
        layout()
        style()
        NotificationManager().status()
        UIApplication.shared.isStatusBarHidden=true; // for status bar hide
        fetchData(folderName: folders[0])

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setup(){
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        guard let folderBar = folderBar else {
            return
        }
        folderBar.delegate = self
        view.addSubview(folderBar)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(urlCell.self, forCellReuseIdentifier: urlCell.identifier)
        
        view.addSubview(tb)
        tb.delegate = self
        

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
    
    private func layout(){
        guard let folderBar = folderBar else {
            return
        }

        folderBar.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.safeAreaLayoutGuide.leftAnchor,right: view.safeAreaLayoutGuide.rightAnchor,height: view.frame.height * 0.08)
        
        tableView.anchor(top: folderBar.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
    }
    
    private func style(){
        tb.centerX(inView: view)
        tb.anchor(bottom:view.bottomAnchor,paddingBottom: 50,width: view.frame.width * 0.5,height: view.frame.height * 0.1)
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
        let wk = WebView(s: item.feedItemLink)
        present(wk, animated: true, completion: nil)
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
            return
        case .f:
            return
        case .rl:
            return
        }
    }
}

extension ViewController:FolderBarDelegate{
    func switchFolder(folder: String) {
        self.items = []
        fetchData(folderName: folder)
    }
}

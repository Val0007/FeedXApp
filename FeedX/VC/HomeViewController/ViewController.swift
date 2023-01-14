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

    override func viewDidLoad() {
        super.viewDidLoad()
        let folders = db.getFolders()
        folderBar = FolderBar(frame: .zero, f: folders)
        setup()
        layout()
        style()
        NotificationManager().status()
        UIApplication.shared.isStatusBarHidden=true; // for status bar hide
        fetchData()

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
        view.addSubview(folderBar)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tb)
        tb.delegate = self
        

    }
    
    private func fetchData(){
        let folderName = "Motorsport"
        print("FETCHING DATA")
        let resutls = SqlDB.shared.getURLS(foldername: folderName)
        print(resutls)
        for r in resutls{
            Networking().getData(urlP:r.url , pubL: r.publisher)
            print("Results where")
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
        return 5
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = UITableViewCell()
        if var val = UserDefaults.standard.value(forKey: "backk") as? Bool{
            cell.textLabel?.text = "\(val)"
        }
        else{
            cell.textLabel?.text = "Row"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.height * 0.11
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

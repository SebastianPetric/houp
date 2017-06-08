//
//  PublicGroupCollectionViewController.swift
//  Houp
//
//  Created by Sebastian on 28.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class PublicGroupThreadsController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{

    var liveQuery: CBLLiveQuery?
    var publicGroupID = "0"
    var threadsList: [Thread] = [Thread]()
    let threadsCellID = "threadsCellID"
    var widthHeightOfImageViews: CGFloat = 20
    
    deinit {
        liveQuery?.removeObserver(self, forKeyPath: "rows")
    }
    
    lazy var threadsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let threads = UICollectionView(frame: .zero, collectionViewLayout: layout)
        threads.dataSource = self
        threads.delegate = self
        threads.backgroundColor = .white
        return threads
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Öffentliche Themen"
        
        if(liveQuery == nil){
            getTopicThreads(groupID: self.publicGroupID)
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.createIcon.rawValue), style: .plain, target: self, action: #selector(handleCreateThread))
        view.addSubview(threadsCollectionView)
        self.threadsCollectionView.register(PrivateGroupThreadsCell.self, forCellWithReuseIdentifier: threadsCellID)
        setUpSubViews()
    }
    
    func setUpSubViews(){
        threadsCollectionView.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: threadsCellID, for: indexPath) as! PrivateGroupThreadsCell
        //new
        cell.thread = TempStorageAndCompare.shared.getAllThreadsOfGroup(groupID: self.publicGroupID)[indexPath.row]
        //-----
        
        //cell.thread = self.threadsList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //new
        return TempStorageAndCompare.shared.getAllThreadsOfGroup(groupID: self.publicGroupID).count
        //----
        
        //return self.threadsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = GroupCommentsController()
        
        
        //new
        var tempList = TempStorageAndCompare.shared.getAllGroupsWithThreads()[self.publicGroupID]
        tempList?[indexPath.row].hasBeenUpdated = false
        TempStorageAndCompare.shared.saveAllThreadsOfGroup(groupID: self.publicGroupID, threads: tempList!)
        self.threadsCollectionView.reloadData()
        controller.thread = TempStorageAndCompare.shared.getAllThreadsOfGroup(groupID: self.publicGroupID)[indexPath.row]
        //-----

        //controller.thread = threadsList[indexPath.row]
        controller.titleNav = "Öffentliches Thema"
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

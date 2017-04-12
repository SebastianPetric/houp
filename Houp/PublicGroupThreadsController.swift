//
//  PublicGroupCollectionViewController.swift
//  Houp
//
//  Created by Sebastian on 28.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class PublicGroupThreadsController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{

    let threadsCellID = "threadsCellID"
    var widthHeightOfImageViews: CGFloat = 20
    
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
        self.title = "Themen"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        view.backgroundColor = .white
        threadsCollectionView.register(PublicGroupThreadsCell.self, forCellWithReuseIdentifier: threadsCellID)
        view.addSubview(threadsCollectionView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.createIcon.rawValue), style: .plain, target: self, action: #selector(handleCreateThread))
        setUpSubViews()
    }
    
    func setUpSubViews(){
    threadsCollectionView.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let string = "Hallo leute, also wie gesagt ich hätte folgendes Problem. Und zwar geht es darum, dass ich nciht weiß was ich machen soll. Bla bla bla bl fejfwpeokfew kofwekowefkewf kfekoefwkewf kokwefokwefpwfe oooooo"
//        
//        let approximateWidth = view.frame.width - 55
//        let sizeTitleMessage = CGSize(width: approximateWidth, height: 1000)
//        let attributesMessage = [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
//        let estimateMessageHeight = NSString(string: string).boundingRect(with: sizeTitleMessage, options: .usesLineFragmentOrigin, attributes: attributesMessage, context: nil)
//        let heightMessage = estimateMessageHeight.height + 66
        
        return CGSize(width: view.frame.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: threadsCellID, for: indexPath) as! PublicGroupThreadsCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(PublicGroupThreadWithComments(), animated: true)
    }
    
    
    func handleCreateThread(){
        let createController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: CreateGroupThreadController(), navBarTitle: "Thread erstellen", barItemTitle: "", image: "")
        self.present(createController, animated: true, completion: nil)
    }
}

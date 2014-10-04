//
//  ViewController.swift
//  Buttons
//
//  Created by J.T. Cho on 10/4/14.
//  Copyright (c) 2014 taymakes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView?
    
    let TOP_PADDING : CGFloat = 150;
    let BOTTOM_PADDING : CGFloat = 80;
    let SIDE_PADDING : CGFloat = 60;
    let ITEM_SIZE : CGFloat = 45;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Additional stuff.
        //Create a new collection view flow layout.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //Padding from the sides.
        layout.sectionInset = UIEdgeInsets(top: TOP_PADDING, left: SIDE_PADDING, bottom: BOTTOM_PADDING,
                                           right: SIDE_PADDING)
        //Item size for each cell.
        layout.itemSize = CGSize(width: ITEM_SIZE, height: ITEM_SIZE)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout : layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(CFCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 32
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as CFCell
        cell.imageView.image = UIImage(named: "star")
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row);
    }
    
}


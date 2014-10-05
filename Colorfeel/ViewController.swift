//
//  ViewController.swift
//  Buttons
//
//  Created by J.T. Cho on 10/4/14.
//  Copyright (c) 2014 taymakes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource {
    
    var collectionView: UICollectionView?
    
    let TOP_PADDING     : CGFloat = 150;
    let BOTTOM_PADDING  : CGFloat = 80;
    let SIDE_PADDING    : CGFloat = 64;
    let ITEM_SIZE       : CGFloat = 45;
    
    //Hex Codes for Color Squares
    let hexCodes : [Int] = [0xFF9999, 0xCC6666, 0x993333, 0x660000,  // red
        0xFDCC9A, 0xF79868, 0xCC6633, 0x993300,  // orange
        0xFFE5B6, 0xFFCC66, 0xCC9933, 0x996600,  // yellow
        0xCFE295, 0x99CC66, 0x669940, 0x356732,  // green
        0xC8E8E8, 0x99CCCC, 0x669999, 0x336667,  // teal
        0xD3E3F1, 0x9FC9EB, 0x6699CC, 0x33669A,  // blue
        0xEBCEE3, 0xCB9AC6, 0x996699, 0x663366,  // purple
        0xFBDEEB, 0xF499C1, 0xCC6699, 0x9A3466]  // pink
    
    //Converts a given hex value and alpha into a representable color .
    func colorize (hex: Int, alpha: Double) -> UIColor {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        var color: UIColor = UIColor(red: CGFloat(red), green: CGFloat(green),
            blue: CGFloat(blue), alpha:CGFloat(alpha))
        return color
    }
    
    //Runs when the represented view loads.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let BG_COLOR : UIColor = colorize(0xEFEFEF, alpha: 1.0)
        
        //Create a new collection view flow layout.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        //Padding from the sides.
        layout.sectionInset = UIEdgeInsets(top: TOP_PADDING, left: SIDE_PADDING,
            bottom: BOTTOM_PADDING, right: SIDE_PADDING)
        //Item size for each cell.
        layout.itemSize = CGSize(width: ITEM_SIZE, height: ITEM_SIZE)
        collectionView = UICollectionView(frame: self.view.frame,
            collectionViewLayout : layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(CFCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView!.backgroundColor = BG_COLOR
        self.view.addSubview(collectionView!)
    }
    
    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Return the number of elements in the Collection View.
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return 32
    }
    
    //Called when initializing each Collection View element.
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) ->
        UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell",
                forIndexPath: indexPath) as CFCell
            cell.backgroundColor = colorize(hexCodes[indexPath.row], alpha: 1.0);
            return cell
    }
    
    //Called when one of the elements of the Collection View is pressed.
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as CFCell
            
            // if clicked, send color value over to edit view
            performSegueWithIdentifier("color_select", sender: indexPath)
    }
    
    override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
        println("Somebody once told me the world was gonna roll me...")
        super.performSegueWithIdentifier(identifier!, sender:sender);
    }
}


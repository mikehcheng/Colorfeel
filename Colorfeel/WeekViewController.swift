//
//  WeekViewController.swift
//  Colorfeel
//
//  Created by Nancy Wong on 10/5/14.
//  Copyright (c) 2014 Michael Cheng. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController, UICollectionViewDelegateFlowLayout,
                          UICollectionViewDataSource {
    
    var collectionView: UICollectionView?
    
    let TOP_PADDING     : CGFloat = 150;
    let BOTTOM_PADDING  : CGFloat = 80;
    let SIDE_PADDING    : CGFloat = 150;
    let ITEM_SIZE       : CGFloat = 35;
    
    // primary colors for Sun - Sat
    // if no color data found, light grey 0xF0EFEF
    let hexCodes : [Int] = [0xFF9999, 0xCC6666, 0x993333, 0x660000,
                            0xFDCC9A, 0xF79868, 0xCC6633]
    
    func colorize (hex: Int, alpha: Double) -> UIColor {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        var color: UIColor = UIColor(red: CGFloat(red), green: CGFloat(green),
            blue: CGFloat(blue), alpha:CGFloat(alpha))
        return color
    }
    
    override func viewDidLoad() {
        let BG_COLOR : UIColor = colorize(0xEFEFEF, alpha: 1.0)
        
        super.viewDidLoad()
        
        var date = UILabel(frame: CGRectMake(0, 0, 400, 21))
        date.center = CGPointMake(188, 200)
        date.textAlignment = NSTextAlignment.Center
        date.textColor = colorize(0x727373, alpha: 1.0);
        date.text = ""
        //  NSString *displayString = [NSDate stringForDisplayFromDate:date];
        self.view.addSubview(date)
        
        //Additional stuff.
        //Create a new collection view flow layout.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //Padding from the sides.
        layout.sectionInset = UIEdgeInsets(top: TOP_PADDING, left: SIDE_PADDING,
            bottom: BOTTOM_PADDING, right: SIDE_PADDING)
        //Item size for each cell.
        layout.itemSize = CGSize(width: ITEM_SIZE, height: ITEM_SIZE)
        layout.minimumLineSpacing = 30
        collectionView = UICollectionView(frame: self.view.frame,
            collectionViewLayout : layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(CFCell.self,
            forCellWithReuseIdentifier: "Cell")
        collectionView!.backgroundColor = BG_COLOR
        self.view.addSubview(collectionView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Return the number of elements in the Collection View.
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return 7
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
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            var cellcolor = cell?.backgroundColor
            collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as CFCell
            
            // if clicked, send color value over to edit view
//            performSegueWithIdentifier("color_select", sender: cellcolor)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  //      print(sender)
//        if segue.identifier == "color_select" {
    //        var svc: DayViewController = segue.destinationViewController as DayViewController
      //      svc.inputColor = sender! as UIColor
        //}
    }
}
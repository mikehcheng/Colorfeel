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
        
        //Set up the swipe handler.
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "handleSwipeGestureRight:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
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
        
        
        var date = UILabel(frame: CGRectMake(0, 0, 400, 30))
        //var date = UILabel(frame: CGRectMake(0, 0, view.frame.width, view.frame.height - TOP_PADDING - BOTTOM_PADDING))
        date.center = CGPointMake(188, 95)
        date.textAlignment = NSTextAlignment.Center
        date.textColor = colorize(0x727373, alpha: 1.0);
        date.font = UIFont(name: "HelveticaNeue", size: CGFloat(26))
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        var oldseconds = NSDate().timeIntervalSince1970 - Double(6 * 86400)
        var oldDate = NSDate(timeIntervalSince1970: oldseconds)
        var dateDisplay = dateFormatter.stringFromDate(oldDate) + " - " +
            dateFormatter.stringFromDate(NSDate.date())
        println(dateDisplay)
        date.text = dateDisplay
        self.view.addSubview(date)
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
            
            performSegueWithIdentifier("back_day_view", sender: indexPath.row)
    }
    
    override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
        super.performSegueWithIdentifier(identifier!, sender:sender);
    }
    
    func handleSwipeGestureRight(gesture : UIGestureRecognizer) {
        performSegueWithIdentifier("back_day_view", sender: gesture)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var svc: DayViewController = segue.destinationViewController as DayViewController
        svc.editingNote = false
        if sender is UISwipeGestureRecognizer && (sender as UISwipeGestureRecognizer).direction == .Right {
            //use current date for swipe back
            svc.inputDate = NSDate()
        } else if sender is Int {
            var oldseconds = NSDate().timeIntervalSince1970 - Double((6 - (sender as Int)) * 86400)
            var oldDate = NSDate(timeIntervalSince1970: oldseconds)
            svc.inputDate = oldDate
        }
    }
    
}
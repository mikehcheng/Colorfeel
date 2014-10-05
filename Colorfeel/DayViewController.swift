//
//  ViewController.swift
//  test
//
//  Created by Lynda Tang on 10/4/14.
//  Copyright (c) 2014 Lynda Tang. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, UITextViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let SIDE_PADDING    : CGFloat = 43;
    let TOP_PADDING     : CGFloat = 85;
    
    let NILTIME         : NSDate = NSDate(timeIntervalSince1970: 0)
    
    @IBOutlet weak var notes: UITextView!
    
    var inputColor: UIColor!
    var inputDate: NSDate!
    var editingNote: Bool!
    
    var dayEntries = [ColorEntry]()
    
    var imageView:UIImageView = UIImageView()
    
    func colorize (hex: Int, alpha: Double) -> UIColor {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        var color: UIColor = UIColor(red: CGFloat(red), green: CGFloat(green),
            blue: CGFloat(blue), alpha:CGFloat(alpha))
        return color
    }
    
    override func viewDidLoad() {
        var dbc = DatabaseController()
        dayEntries = dbc.getEntries(inputDate)
        if((editingNote) != nil && editingNote!) {
            //creating new color
            dayEntries.append(ColorEntry(color: inputColor, time: NILTIME))
        }
        
        let BG_COLOR : UIColor = colorize(0xEFEFEF, alpha: 1.0)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Set up the swipe handler.
        var swipeRec = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        swipeRec.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRec)
        
        notes.delegate = self
        notes.returnKeyType = UIReturnKeyType.Done
        
        let width: CGFloat = 200;
        let height: CGFloat = 200;
        
        var view:UIView = UIView(frame: CGRectMake(SIDE_PADDING, TOP_PADDING,
                                                   width, height))
        self.view.addSubview(view);
        
        self.view.backgroundColor = BG_COLOR
        
        imageView = UIImageView(frame: view.frame)
        imageView.backgroundColor = inputColor
        view.addSubview(imageView);
        
        //Bottom Slider
        let svframe: CGRect = CGRectMake(43, 500, 300, 64)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0,
            bottom: 10.0, right: 10.0)
        layout.itemSize = CGSize(width: 45.0, height: 45.0)
        layout.scrollDirection = .Horizontal
        var collectionView = UICollectionView(frame: svframe,
            collectionViewLayout : layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(CFCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = colorize(0xA8A8A8, alpha: 0.3)
        self.view.addSubview(collectionView)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            dayEntries[dayEntries.count-1].time = NSDate()
            dayEntries[dayEntries.count-1].note = notes.text
            var dbc = DatabaseController()
            dbc.createEntry(dayEntries[dayEntries.count-1].color, note: dayEntries[dayEntries.count-1].note?)
            editingNote = false
            notes.editable = false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipeGesture(gesture : UIGestureRecognizer) {
        performSegueWithIdentifier("back_color_select", sender: gesture.view)
    }
    
    //UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return dayEntries.count
    }
    
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
            //last element is edited, only if editingNote
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            imageView.backgroundColor = cell?.backgroundColor
            notes.text = (dayEntries[indexPath.row].note? == nil ? "" : dayEntries[indexPath.row].note!)
            if ((editingNote) != nil && editingNote!) {
                notes.editable = true
            } else {
                //was editing most recent
                if notes.editable == true {
                    dayEntries[dayEntries.count-1].note = notes.text
                }
                notes.editable = false
            }
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell",
                forIndexPath: indexPath) as CFCell
            cell.backgroundColor = dayEntries[indexPath.row].color
            return cell
    }
}


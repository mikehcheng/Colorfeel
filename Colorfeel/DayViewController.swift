//
//  ViewController.swift
//  test
//
//  Created by Lynda Tang on 10/4/14.
//  Copyright (c) 2014 Lynda Tang. All rights reserved.
//

import Foundation
import UIKit

class DayViewController: UIViewController, UITextViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let SIDE_PADDING    : CGFloat = 43;
    let TOP_PADDING     : CGFloat = 75;
    
    let NILTIME         : NSDate = NSDate(timeIntervalSince1970: 0)
    
    @IBOutlet weak var notes: UITextView!
    
    var inputColor: UIColor?
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
            dayEntries.append(ColorEntry(color: inputColor!, time: NILTIME))
        }
        
        let BG_COLOR : UIColor = colorize(0xEFEFEF, alpha: 1.0)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var date = UILabel(frame: CGRectMake(0, 0, 400, 30))
        date.center = CGPointMake(188, 95)
        date.textAlignment = NSTextAlignment.Center
        date.textColor = colorize(0x727373, alpha: 1.0);
        date.font = UIFont(name: "HelveticaNeue", size: CGFloat(27))
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        date.text = dateFormatter.stringFromDate(inputDate)
        self.view.addSubview(date)
        
        var label = UILabel(frame: CGRectMake(0, 0, 400, 21))
        label.center = CGPointMake(188, 374)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = colorize(0x727373, alpha: 1.0);
        label.text = "_______________________________"
        self.view.addSubview(label)
        
        //Set up the swipe handler.
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "handleSwipeGestureRight:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "handleSwipeGestureLeft:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        notes.delegate = self
        notes.returnKeyType = UIReturnKeyType.Done
        if(editingNote == false) {
            notes.text = dayEntries.first!.note!
        }
        
        let width: CGFloat = 200;
        let height: CGFloat = 200;
        
        var view:UIView = UIView(frame: CGRectMake(SIDE_PADDING, TOP_PADDING,
                                                   width, height))
        self.view.addSubview(view);
        
        self.view.backgroundColor = BG_COLOR
        
        //Color Square
        imageView = UIImageView(frame: view.frame)
        imageView.backgroundColor = (inputColor == nil ? dayEntries.first!.color : inputColor!)
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
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
        UIView.animateWithDuration(0.33, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () -> Void in
                self.view.transform = CGAffineTransformMakeTranslation(0, -216)
            },
            completion: nil
        )
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            //updates entry and saves
            dayEntries[dayEntries.count-1].time = NSDate()
            dayEntries[dayEntries.count-1].note = notes.text
            var dbc = DatabaseController()
            dbc.createEntry(dayEntries[dayEntries.count-1].color, note: dayEntries[dayEntries.count-1].note?)
            editingNote = false
            notes.editable = false
            //animates response
            UIView.animateWithDuration(0.33, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut,
                animations: { () -> Void in
                    self.view.transform = CGAffineTransformMakeTranslation(0, 0)
                },
                completion: nil
            )
        }
        return true
    }
    
    //Changes to the next color
    //@list: The list of UIColors to parse through
    //@intIndex: The current int
    func toNextColor(list:[UIColor]){
        for i in 0...(list.count - 1) {
            UIView.animateWithDuration(1, delay: 0.2, options: nil, animations:
                {
                    self.imageView.backgroundColor = list[i];
                },
                completion: nil
            )
        }
    }
    
    //Takes a two colors
    //Makes the add pretty
    //@currColor: Current Color
    //@addColor: The color to be added
    //
    //Returns a list of the new kawaii colors inbetween them!
    //SUGOI
    func changePrettyColors(currColor:UIColor, addColor:UIColor) -> Array<UIColor>{
        var returnList: Array<UIColor> = [];
        let startCol = currColor;
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0;
        startCol.getRed(&r, green: &g, blue: &b, alpha: &a);
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0;
        addColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2);
        //xXx Colors in between xXx
        let intercol1:UIColor = UIColor(red:r2, green:g, blue:b, alpha: a);
        let intercol2:UIColor = UIColor(red:r2, green:g2, blue:b, alpha: a);
        //Adds the colors onto the list
        returnList.append(currColor);
        returnList.append(intercol1);
        returnList.append(intercol2);
        returnList.append(addColor);
        return returnList;
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
//            let newbgcolor = cell?.backgroundColor
//            toNextColor(changePrettyColors(imageView.backgroundColor!, addColor: newbgcolor!))
            if ((editingNote) != nil && editingNote! && indexPath.row == dayEntries.count - 1) {
                notes.editable = true
            } else {
                //was editing most recent
                if notes.editable == true {
                    dayEntries[dayEntries.count-1].note = notes.text
                }
                notes.editable = false
            }
            notes.text = (dayEntries[indexPath.row].note? == nil ? "" : dayEntries[indexPath.row].note!)
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell",
                forIndexPath: indexPath) as CFCell
            cell.backgroundColor = dayEntries[indexPath.row].color
            return cell
    }
    
    func handleSwipeGestureRight(gesture : UIGestureRecognizer) {
        performSegueWithIdentifier("back_color_select", sender: gesture.view)
    }
    
    func handleSwipeGestureLeft(gesture : UIGestureRecognizer) {
        performSegueWithIdentifier("week_view", sender: gesture.view)
    }
}


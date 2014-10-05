//
//  ViewController.swift
//  test
//
//  Created by Lynda Tang on 10/4/14.
//  Copyright (c) 2014 Lynda Tang. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, UITextViewDelegate {
    
    let SIDE_PADDING    : CGFloat = 43;
    let TOP_PADDING     : CGFloat = 85;
    
    @IBOutlet weak var notes: UITextView!
    
    var inputColor: UIColor!
    
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
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
        super.performSegueWithIdentifier(identifier!, sender:sender);
    }
    
    func handleSwipeGesture(gesture : UIGestureRecognizer) {
        performSegueWithIdentifier("back_color_select", sender: gesture.view)
    }
}


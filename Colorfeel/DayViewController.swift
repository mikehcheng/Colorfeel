//
//  ViewController.swift
//  test
//
//  Created by Lynda Tang on 10/4/14.
//  Copyright (c) 2014 Lynda Tang. All rights reserved.
//

import UIKit

class DayViewController: UIViewController {
    
    var imageView:UIImageView = UIImageView()
    var backgroundColDict:Dictionary<String,UIColor> = Dictionary()
    var moodColors : [UIColor] = [UIColor(red:0.52, green:0.52, blue:1.0, alpha:1.0),
        UIColor(red:1.0, green:0.8, blue:0.0, alpha:1.0),
        UIColor(red:0, green:1, blue:0.0, alpha:1.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let width: CGFloat = 200;
        let height: CGFloat = 200;
        
        backgroundColDict = ["Purple":UIColor(red:0.52, green:0.52, blue:1.0, alpha:1.0), "Orange":UIColor(red:1.0, green:0.8, blue:0.0, alpha:1.0)]
        
        var buttonTitles = ["Purple","Orange"]
        
        var view:UIView = UIView(frame: CGRectMake(0, 0, width, height))
        
        self.view.addSubview(view);
        
        var backgroundCol:UIColor = backgroundColDict["Purple"]!
        
        imageView = UIImageView(frame: view.frame)
        imageView.backgroundColor = backgroundColDict["Purple"]
        
        view.addSubview(imageView);
        
        changeBackgroundColor(self.makePrettyColors(self.moodColors));
        
    }
    
    //Changes the background colors
    //@list: The list of colors to go through
    func changeBackgroundColor(list:[UIColor]){
        
        self.toNextColor(list, intIndex: 0);
        
    }
    
    //Changes to the next color
    //@list: The list of UIColors to parse through
    //@intIndex: The current int
    func toNextColor(list:[UIColor], intIndex: Int){
        UIView.animateWithDuration(3.0, delay: 0.2, options: nil, animations:
            {
                self.imageView.backgroundColor = list[intIndex];
                //println(intIndex);
            },
            completion: {finished in self.toNextColor(list,intIndex:(intIndex+1)%list.count)})
        
    }
    
    //Takes an array and makes the transitions pretty desu
    //
    //Returns the kpsurgeried color array
    func makePrettyColors(list:[UIColor]) ->Array<UIColor>{
        //var index = 0;
        var prettyColorList: Array<UIColor> = [];
        for index in 0...(list.count-2) {
            prettyColorList = prettyColorList + changePrettyColors(list[index], addColor: list[index+1])
        }
        
        return prettyColorList;
    }
    
    //Takes a two colors
    //Makes the add pretty kawaii desu
    //
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
    
    
    
}
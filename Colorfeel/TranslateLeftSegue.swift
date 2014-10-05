//
//  SLIGHT MISNOMER, TRANSLATE RIGHT SHOULD BE TRANSLATE LEFT
//
//  TranslateRightSegue.swift
//  Colorfeel
//
//  Created by J.T. Cho on 10/5/14.
//  Copyright (c) 2014 Michael Cheng. All rights reserved.
//

import UIKit

class TranslateLeftSegue : UIStoryboardSegue {
    
    override func perform() {
        var sourceViewController = self.sourceViewController as UIViewController
        var destinationViewController = self.destinationViewController as UIViewController
        
        //Create a screenshot of the old view
        var duplicatedSourceView : UIView = sourceViewController.view.snapshotViewAfterScreenUpdates(false)
        var duplicatedDestView : UIView = destinationViewController.view.snapshotViewAfterScreenUpdates(true)
        
        duplicatedDestView.frame.offset(dx: duplicatedDestView.frame.width, dy: 0)
        //
        destinationViewController.view.addSubview(duplicatedSourceView)
        destinationViewController.view.addSubview(duplicatedDestView)
        
        sourceViewController.presentViewController(destinationViewController, animated: false, completion: {
            UIView.animateWithDuration(0.33, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut,
                animations: { () -> Void in
                    duplicatedDestView.transform = CGAffineTransformMakeTranslation(-duplicatedDestView.frame.width, 0)
            },
                completion: { (finished : Bool) -> Void in
                    //
                    duplicatedSourceView.removeFromSuperview()
                    duplicatedDestView.removeFromSuperview()
            })
        })
    }
   
}

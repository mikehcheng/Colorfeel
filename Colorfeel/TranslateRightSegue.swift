//
//  TranslateLeftSegue.swift
//  Colorfeel
//
//  Created by J.T. Cho on 10/5/14.
//  Copyright (c) 2014 Michael Cheng. All rights reserved.
//

import UIKit

class TranslateRightSegue: UIStoryboardSegue {
    
    override func perform() {
        var sourceViewController = self.sourceViewController as UIViewController
        var destinationViewController = self.destinationViewController as UIViewController
        
        //Create a screenshot of the old view
        var duplicatedSourceView : UIView = sourceViewController.view.snapshotViewAfterScreenUpdates(false)
        //
        destinationViewController.view.addSubview(duplicatedSourceView)
        
        sourceViewController.presentViewController(destinationViewController, animated: false, completion: {
            UIView.animateWithDuration(0.33, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut,
                animations: { () -> Void in
                    duplicatedSourceView.transform = CGAffineTransformMakeTranslation(duplicatedSourceView.frame.width, 0)
                },
                completion: { (finished : Bool) -> Void in
                    //
                    duplicatedSourceView.removeFromSuperview()
            })
        })
    }

}

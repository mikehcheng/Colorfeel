//
//  CFCell.swift
//  Buttons
//
//  Created by J.T. Cho on 10/4/14.
//  Copyright (c) 2014 taymakes. All rights reserved.
//

import UIKit

class CFCell: UICollectionViewCell {
    
    let textLabel: UILabel!
    let imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        contentView.addSubview(imageView)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

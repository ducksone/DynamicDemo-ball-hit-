//
//  BallView.swift
//  DynamicDemo
//
//  Created by duck on 15/6/30.
//  Copyright (c) 2015年 dom.duck. All rights reserved.
//

import UIKit

class BallView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.yellowColor()
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.redColor().CGColor
        self.layer.borderWidth = 2
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

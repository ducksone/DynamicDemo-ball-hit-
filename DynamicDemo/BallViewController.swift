//
//  BallViewController.swift
//  DynamicDemo
//
//  Created by duck on 15/6/30.
//  Copyright (c) 2015年 dom.duck. All rights reserved.
//

import UIKit

class BallViewController: UIViewController,UIDynamicAnimatorDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "球"
        
        self.view = BallsContentView(frame: self.view.bounds)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

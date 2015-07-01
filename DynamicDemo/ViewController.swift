//
//  ViewController.swift
//  DynamicDemo
//
//  Created by duck on 15/6/29.
//  Copyright (c) 2015年 dom.duck. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var sourceArray : NSMutableArray = NSMutableArray(arrayLiteral: "撞机效果")
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationItem.title = "物理仿真测试"
        
    }
    
    
    //MARK: UITableViewDelegate UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "dy")
        }
        
        if indexPath.row == 0
        {
            cell!.textLabel!.text = sourceArray.objectAtIndex(indexPath.row) as? String
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0
        {
            self.performSegueWithIdentifier("ballSeg", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}


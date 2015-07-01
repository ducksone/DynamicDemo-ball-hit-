//
//  BallsContentView.swift
//  DynamicDemo
//
//  Created by duck on 15/7/1.
//  Copyright (c) 2015年 dom.duck. All rights reserved.
//

import UIKit

class BallsContentView: UIView {

    var animator : UIDynamicAnimator?
    var ballCount : NSInteger?
    var ballsArray : NSMutableArray = NSMutableArray()
    var anchorsArray : NSMutableArray = NSMutableArray()
    var userDragBehavior : UIPushBehavior?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ballCount = 5
        
        self.createBallsAndAnchors()
        self.applyDynamicBehaviors()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
    *创建球和锚点
    */
    func createBallsAndAnchors()
    {
        var ballSize : CGFloat = CGRectGetWidth(self.bounds) / CGFloat(3*(ballCount! - 1))
        
        for var index : Int = 0 ; index < ballCount! ; ++index
        {
            var ball : BallView = BallView(frame: CGRectMake(0, 0, ballSize - 1, ballSize - 1))
            var x : CGFloat = CGRectGetWidth(self.bounds) / 3.0 + CGFloat(index) * ballSize
            var y : CGFloat = CGRectGetHeight(self.bounds) / 1.5
            ball.center = CGPointMake(x, y)
            
            var panGesture : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handleBallPan:"))
            ball.addGestureRecognizer(panGesture)
            
            ball.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.New, context: nil)
            
            ballsArray.addObject(ball)
            self.addSubview(ball)
            
            var blueBox = self.createAnchorForBall(ball)
            anchorsArray.addObject(blueBox)
            self.addSubview(blueBox)
        }
        
    }
    
    //MARK:锚点和线条
    func createAnchorForBall(ball : BallView) -> UIView
    {
        var anchor = ball.center
        
        anchor.y -= CGRectGetHeight(self.bounds) / 4.0
        var blueBox = UIView(frame: CGRectMake(0, 0, 10, 10))
        blueBox.backgroundColor = UIColor.blueColor()
        blueBox.center = anchor
        
        return blueBox
    }
    
    func handleBallPan(panGesture : UIPanGestureRecognizer)
    {
        //用户开始拖动时创建一个新的UIPushBehavior,并添加到animator中
        
        if panGesture.state == UIGestureRecognizerState.Began
        {
            if userDragBehavior != nil
            {
                animator!.removeBehavior(userDragBehavior!)
            }
            
            userDragBehavior = UIPushBehavior(items: [panGesture.view!], mode: UIPushBehaviorMode.Continuous)
            
            animator!.addBehavior(userDragBehavior!)
        }
        
        userDragBehavior!.pushDirection = CGVectorMake(panGesture.translationInView(self).x / 10.0, 0)
        if panGesture.state == UIGestureRecognizerState.Ended
        {
            animator!.removeBehavior(userDragBehavior!)
            userDragBehavior = nil
            
        }
        
        
    }
    
    
    func applyDynamicBehaviors()
    {
        var behavior : UIDynamicBehavior = UIDynamicBehavior()
        
        self.applyAttachBehaviorForBalls(behavior)
        behavior.addChildBehavior(self.createGravityBehaviorForObjects(ballsArray as NSArray))
        behavior.addChildBehavior(self.createCollisionBehaviorForObjects(ballsArray as NSArray))
        behavior.addChildBehavior(self.createItemBehavior())
        
        animator = UIDynamicAnimator(referenceView: self)
        animator!.addBehavior(behavior)
    }
    
    func applyAttachBehaviorForBalls(behavior : UIDynamicBehavior)
    {
        for var index : Int = 0 ; index < ballCount! ; ++index
        {
            var attachmentBehavior : UIDynamicBehavior = self.createAttachmentBehaviorForBallBearing(ballsArray.objectAtIndex(index), toAnchor: anchorsArray.objectAtIndex(index))
            behavior.addChildBehavior(attachmentBehavior)
        }
    }
    
    //MARK: 把球attach到锚点上
    func createAttachmentBehaviorForBallBearing(ballBearing : AnyObject , toAnchor : AnyObject) -> UIDynamicBehavior
    {
        var behavior : UIAttachmentBehavior = UIAttachmentBehavior(item: ballBearing as! UIDynamicItem, attachedToAnchor: (toAnchor as! UIDynamicItem).center)
        
        return behavior
    }
    
    //MARK: 为所有的球添加一个重力行为
    func createGravityBehaviorForObjects(objects : NSArray) -> UIDynamicBehavior
    {
        var gravity : UIGravityBehavior = UIGravityBehavior(items: objects as [AnyObject])
        gravity.magnitude = 10
        return gravity
    }
    
    //MARK: 为所有的球添加一个碰撞行为
    func createCollisionBehaviorForObjects(objects : NSArray) -> UIDynamicBehavior
    {
        return UICollisionBehavior(items: objects as [AnyObject])
    }
    
    //MARK: 为所有的球的动力行为做一个公有配置，像空气阻力，摩擦力，弹性密度等
    func createItemBehavior() -> UIDynamicItemBehavior
    {
        var itemBehavior : UIDynamicItemBehavior = UIDynamicItemBehavior(items: ballsArray as [AnyObject])
        
        itemBehavior.elasticity = 1.0
        itemBehavior.allowsRotation = false
        itemBehavior.resistance = 1.0
        
        return itemBehavior
    }
    
    //MARK: Observer 当ball的center属性发生变化时，刷新整个view
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        self.setNeedsDisplay()
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        var content = UIGraphicsGetCurrentContext()
        for ballBearing in ballsArray
        {
            var anchor = anchorsArray.objectAtIndex(ballsArray.indexOfObject(ballBearing)).center
            
            var ballCenter = ballBearing.center
            
            CGContextMoveToPoint(content, anchor.x, anchor.y)
            CGContextAddLineToPoint(content, ballCenter.x, ballCenter.y)
            CGContextSetLineWidth(content, 1.0)
            UIColor.blackColor().setStroke()
            CGContextDrawPath(content, kCGPathFillStroke)
        }
        
        self.backgroundColor = UIColor.whiteColor()
        
    }
    
    deinit
    {
        for oneBall in ballsArray
        {
            oneBall.removeObserver(self, forKeyPath: "center")
        }
    }

}

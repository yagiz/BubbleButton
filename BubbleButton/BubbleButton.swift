//
//  BubbleButton.swift
//  BubbleButton
//
//  Created by Yagiz Gurgul on 04/12/16.
//  Copyright © 2016 Lab. All rights reserved.
//

import UIKit

public enum BubbleDirection
{
    case Top
    case Left
    case Bottom
    case Right
    
    case TopLeft
    case TopRight
    case BottomLeft
    case BottomRight
}

open class BubbleButton : UIButton
{
    var bubbleDirection:BubbleDirection = .Top {
        didSet
        {
            self.calculateDirectionVector()
        }
    }
    

    public var defaultTitle:String!
    @IBInspectable public var titleForProgress:String!
    @IBInspectable public var titleForCompletion:String!
    
    @IBInspectable public var endAnimationDuration:Float = 0.8
    @IBInspectable public var fadeOutAnimationDelay:Float = 0.5
    @IBInspectable public var fadeOutAnimationDuration:Float = 0.5
    
    @IBInspectable public var bubbleColor:UIColor = UIColor.black
    @IBInspectable public var bubbleCount:Int = 10
    
    @IBInspectable public var bubbleSpeedMin:CGFloat = 3
    @IBInspectable public var bubbleSpeedMax:CGFloat = 6
    
    @IBInspectable public var bubbleRadiusMin:CGFloat = 5
    @IBInspectable public var bubbleRadiusMax:CGFloat = 20
    
    var bubbleVector:CGPoint = CGPoint()
    
    var bubbleDirectionMultiplier:CGPoint!
    
    var bubbles:[BubbleView] = []
    
    var updateder:CADisplayLink!

    var initted:Bool = false
    
    var bigBubble:BubbleView!
    
    override open func layoutSubviews()
    {
        super.layoutSubviews()
        self.calculateBubbleVelocity()
        
        if(!initted)
        {
            self.calculateDirectionVector()
            self.clipsToBounds = true
            self.defaultTitle = self.title(for: .normal)
            initted = true
        }
    }
    
    func createBubbles()
    {
        for _ in 0...bubbleCount
        {
            let bubbleView = BubbleView(color: self.bubbleColor)
            bubbles.append(bubbleView)
            self.insertSubview(bubbleView, belowSubview: self.titleLabel!)
            self.refreshBubbleView(bubbleView: bubbleView)
        }
    }
    
    func calculateBubbleVelocity()
    {
        let a:CGFloat = self.frame.size.width*0.5
        let b:CGFloat = self.frame.size.height*0.5
        let d:CGFloat = CGFloat(sqrtf(Float(a*a + b*b)))
        
        self.bubbleVector = CGPoint(x:a/d,y:b/d)
    }
    
    func calculateDirectionVector()
    {
        switch self.bubbleDirection {
            
        case .Top:
            self.bubbleDirectionMultiplier =  CGPoint(x: 0, y: 1)
        case .Left:
            self.bubbleDirectionMultiplier =  CGPoint(x: -1, y: 0)
        case .Bottom:
            self.bubbleDirectionMultiplier =  CGPoint(x: 0, y: -1)
        case .Right:
            self.bubbleDirectionMultiplier =  CGPoint(x: 1, y: 0)
        
        case .BottomLeft:
            self.bubbleDirectionMultiplier =  CGPoint(x: -1, y: -1)
        case .BottomRight:
            self.bubbleDirectionMultiplier =  CGPoint(x: 1, y: -1)
    
        case .TopRight:
            self.bubbleDirectionMultiplier =  CGPoint(x: -1, y: 1)
        case .TopLeft:
            self.bubbleDirectionMultiplier =  CGPoint(x: 1, y: 1)
            
        }
    }
    
    func getCenterBetween(min:CGFloat,max:CGFloat) -> CGFloat
    {
        return (min + max) * 0.5
    }
    
    func getRandomBetween(min:CGFloat,max:CGFloat) -> CGFloat
    {
        let difference = max-min
        
        if difference < 0
        {
            return min - CGFloat(arc4random_uniform(UInt32(abs(difference))))
        }
        
        return min + CGFloat(arc4random_uniform(UInt32(difference)))
    }
    
    
    func getStartCenter() -> CGPoint
    {
        let minX:CGFloat = self.bubbleDirectionMultiplier.x * self.frame.size.width
        let minY:CGFloat = self.bubbleDirectionMultiplier.y * self.frame.size.height
        
        let maxX:CGFloat = (self.bubbleDirectionMultiplier.x+1) * (self.frame.size.width)
        let maxY:CGFloat = (self.bubbleDirectionMultiplier.y+1) * (self.frame.size.height)
        
        return CGPoint(x: self.getRandomBetween(min: minX, max: maxX),
                       y: self.getRandomBetween(min: minY, max: maxY))
        
    }
    
    func getFinishCenter(startCenter:CGPoint) -> CGPoint
    {
        let finishX = startCenter.x - self.bubbleDirectionMultiplier.x * self.frame.size.width * 2
        let finishY = startCenter.y - self.bubbleDirectionMultiplier.y * self.frame.size.height * 2
     
        return CGPoint(x: finishX,
                       y: finishY)
    }
    
    func refreshBubbleView(bubbleView:BubbleView)
    {
        let speed = self.getRandomBetween(min: self.bubbleSpeedMin, max: self.bubbleSpeedMax)
        
        bubbleView.velocity = CGPoint(x:self.bubbleVector.x * speed,
                                      y:self.bubbleVector.y * speed)
        
        bubbleView.radius = self.getRandomBetween(min: bubbleRadiusMin, max: bubbleRadiusMax)
        
        bubbleView.startCenter = self.getStartCenter()
        
        bubbleView.finishCenter = self.getFinishCenter(startCenter: bubbleView.startCenter)
        
        bubbleView.refresh()
        
    }
    
    func updateBubbles()
    {
        let selfRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        for bubbleView in self.bubbles
        {
            bubbleView.center = CGPoint(x: bubbleView.center.x - bubbleView.velocity.x * self.bubbleDirectionMultiplier.x,
                                        y: bubbleView.center.y - bubbleView.velocity.y * self.bubbleDirectionMultiplier.y)

            var shouldRefresh = false
            if self.bubbleDirectionMultiplier.x > 0
            {
                if bubbleView.center.x < bubbleView.finishCenter.x
                {
                    shouldRefresh = true
                }
            }else if self.bubbleDirectionMultiplier.x < 0
            {
                if bubbleView.center.x > bubbleView.finishCenter.x
                {
                    shouldRefresh = true
                }
            }
            
            if self.bubbleDirectionMultiplier.y > 0
            {
                if bubbleView.center.y < bubbleView.finishCenter.y
                {
                    shouldRefresh = true
                }
            }else if self.bubbleDirectionMultiplier.y < 0
            {
                if bubbleView.center.y > bubbleView.finishCenter.y
                {
                    shouldRefresh = true
                }
            }
            
            if !selfRect.intersects(bubbleView.frame) && shouldRefresh == true
            {
                self.refreshBubbleView(bubbleView: bubbleView)
            }
        }
    }
    
    public func startBubbleAnimationWith(direction:BubbleDirection)
    {
        self.isUserInteractionEnabled = false
        self.bubbleDirection = direction
        if self.bubbles.count == 0
        {
            self.createBubbles()
        }
        
        self.updateder = CADisplayLink(target: self, selector: #selector(self.updateBubbles))
        self.updateder.preferredFramesPerSecond = 60
        self.updateder.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        
        self.setTitle(self.titleForProgress, for: .normal)
    }
    
    public func endAnimationWith(complation:@escaping ()->Void)
    {
        let a:CGFloat = self.frame.size.width*0.5
        let b:CGFloat = self.frame.size.height*0.5
        let d:CGFloat = CGFloat(sqrtf(Float(a*a + b*b)))
        
        self.bigBubble = BubbleView(color: self.bubbleColor)
        self.bigBubble.radius = d
        self.insertSubview(self.bigBubble, at: 0)
        
        let centerX:CGFloat = self.bubbleDirectionMultiplier.x * self.frame.size.width + self.frame.size.width * 0.5 + self.bubbleDirectionMultiplier.x * d
        let centerY:CGFloat = self.bubbleDirectionMultiplier.y * self.frame.size.height + self.frame.size.height * 0.5 + self.bubbleDirectionMultiplier.y * d
        
        self.bigBubble.startCenter =  CGPoint(x: centerX,
                                              y: centerY)
        
        self.bigBubble.refresh()
        
        self.setTitle(self.titleForCompletion, for: .normal)
        
        UIView.animate(withDuration: TimeInterval(self.endAnimationDuration), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            
            self.bigBubble.center = CGPoint(x: self.frame.size.width * 0.5,
                                            y: self.frame.size.height * 0.5)
            
        }) { (Bool) in
            
            self.clearBubbles()
            
    
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(self.fadeOutAnimationDelay))
            {
                self.setTitle(self.defaultTitle, for: .normal)
                
                UIView.animate(withDuration: TimeInterval(self.fadeOutAnimationDuration), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    
                    self.bigBubble.alpha = 0
                    
                }) { (Bool) in
                    
                    self.isUserInteractionEnabled = true
                    complation()
                }
            }
        }
    }
    
    func clearBubbles()
    {
        self.updateder.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
        self.updateder.invalidate()
        
        for bubbleView in self.bubbles
        {
            bubbleView.removeFromSuperview()
        }
        
        self.bubbles.removeAll()
    }
}

class BubbleView: UIView
{
    var startCenter = CGPoint()
    var finishCenter = CGPoint()
    var radius:CGFloat = 0
    var velocity:CGPoint = CGPoint()
    var color:UIColor = UIColor.white
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    init(color:UIColor)
    {
        super.init(frame: CGRect())
        self.backgroundColor = color
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func refresh()
    {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.radius*2, height: self.radius*2)
        self.center = self.startCenter
        self.layer.cornerRadius = self.radius
    }
}


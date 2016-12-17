//
//  ViewController.swift
//  BubbleButton
//
//  Created by Yagiz Gurgul on 04/12/16.
//  Copyright © 2016 Lab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bubbleButton: BubbleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonAction(_ sender: AnyObject)
    {
        bubbleButton.startBubbleAnimationWith(direction: .TopRight)
        print("startingAnimation")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            print("endingAnimation")
            self.bubbleButton.endAnimationWith {
                print("animationIsEnded")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5)
                {
                    self.buttonAction(sender)
                }
            }
        }
    }
}


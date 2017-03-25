//
//  BoothShape.swift
//  Skeye
//
//  Created by Kevin Dang on 2/13/17.
//  Copyright © 2017 Team_Parking. All rights reserved.
//

import UIKit

class BoothShape
{
    var button: UIButton
    var origin: CGPoint
    var rectangle: CGSize
    var image: String
    var col: String
    var zoom: UIPinchGestureRecognizer
    var select: UITapGestureRecognizer
    var move: UIPanGestureRecognizer
    
    var name: String = ""
    var info: String = ""
    var date: String = ""
    //var picture: UIImage? = nil
    var boothPhotos : [UIImage] = []
    
    init(_ point: CGPoint, _ size: CGSize, _ shape: String, _ color: String)
    {
        origin = point
        rectangle = size
        image = shape
        col = color
        button = UIButton()
        zoom = UIPinchGestureRecognizer.init()
        select = UITapGestureRecognizer.init()
        move = UIPanGestureRecognizer.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
     */
    func draw(_ rect: CGRect)
    {
        button = UIButton.init(frame: CGRect.init(origin: CGPoint.init(x: origin.x - rectangle.width/2, y: origin.y - rectangle.height/2), size: rectangle))
        button.setTitle("Test!", for: UIControlState.normal)
        switch(image)
        {
        case "circle":
            switch(col)
            {
            case("white"):
                button.setBackgroundImage(UIImage.init(named: "WhiteCircle"), for: UIControlState.normal)
            case("red"):
                button.setBackgroundImage(UIImage.init(named: "RedCircle"), for: UIControlState.normal)
            default: break
            }
        default: break
        }
        zoom = UIPinchGestureRecognizer.init(target: self, action: #selector(pinch))
        select = UITapGestureRecognizer.init(target: self, action: #selector(tap))
        //move = UIPanGestureRecognizer.init(target: self, action: #selector(move))
        self.button.addGestureRecognizer(zoom)
        self.button.addGestureRecognizer(select)
    }
    
     @objc func tap(gesture: UITapGestureRecognizer)
    {
        print("Tap")

        let mapVC = UIApplication.shared.keyWindow?.rootViewController as! MapController
        mapVC.popoverFromBoothMethod(sender: self)
        
        
        if(col == "red")
        {
            
            col = "white"
            button.setBackgroundImage(UIImage.init(named: "WhiteCircle"), for: UIControlState.normal)
        }
        else
        {
            col = "red"
            button.setBackgroundImage(UIImage.init(named: "RedCircle"), for: UIControlState.normal)
        }
    }
    
    @objc func pinch(gesture: UIPinchGestureRecognizer)
    {
        print("PInch")
        if let viewer = gesture.view
        {
            if !(viewer.frame.height < 250 && viewer.frame.width < 250 && gesture.scale < 1)
            {
                viewer.transform = viewer.transform.scaledBy(x: gesture.scale, y: gesture.scale)
                gesture.scale = 1
            }
        }
    }
    
    
    
    

}



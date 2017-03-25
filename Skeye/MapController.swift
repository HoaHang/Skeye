//
//  MapController.swift
//  Skeye
//
//  Created by Kevin Dang on 2/6/17.
//  Copyright © 2017 Team_Parking. All rights reserved.
//

import UIKit

//commented UIVC
class MapController: UIViewController, UIPopoverPresentationControllerDelegate, DataSentDelegate
{
    /* Delegate-related: mainVC implement protocal fucntion*/
    internal func userDidEditInfo(data: String, whichBooth: BoothShape) {
        whichBooth.info = data
    }
    internal func userDidEditName(data: String, whichBooth: BoothShape) {
        whichBooth.name = data
    }
    internal func userDidUploadPic(data: [UIImage], whichBooth: BoothShape){
        whichBooth.boothPhotos = data
    }
    internal func userDidEditDate(data: String, whichBooth: BoothShape) {
        whichBooth.date = data
    }
    
    /* Map Boundaries */
    var frameMinimum: CGFloat = 250 //allowed frame boundaries
    var zoomMinimum: CGFloat = 400 //minimum zoom screen size
    
    /* Booleans */
    var shapeSelected = false //if user selected a shape before tapping on the screen
    
    /* Objects obtained from the database */
    var buttons: [BoothShape] = [BoothShape]() //list of booths
    var image: UIImage? = UIImage.init(named: "MapTemplate") //map image

    /* Gesture recognizers */
    var zoom: UIPinchGestureRecognizer = UIPinchGestureRecognizer.init()
    var select: UITapGestureRecognizer = UITapGestureRecognizer.init()
    var move: UIPanGestureRecognizer = UIPanGestureRecognizer.init()
    
    //retain a reference of selected booth
    var currentBooth: BoothShape? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var test: UIButton!
    {
        didSet
        {
            test.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(testButton)))
        }
    }
    
    @IBOutlet weak var mapImage: UIImageView!
    {
        didSet
        {
            mapImage.image = image
            mapImage.alpha = 0.25
            mapImage.sizeToFit()
            
            zoom = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
            mapImage.addGestureRecognizer(zoom)
            select = UITapGestureRecognizer(target: self, action: #selector(tap))
            mapImage.addGestureRecognizer(select)
            move = UIPanGestureRecognizer(target: self, action: #selector(pan))
            mapImage.addGestureRecognizer(move)
            
        }
    }
    
    /*
     Controls zoom for the map and booths within a specified range
    */
    func pinch(gesture: UIPinchGestureRecognizer)
    {
        if let viewer = gesture.view
        {
            if !(viewer.frame.height < zoomMinimum && viewer.frame.width < zoomMinimum && gesture.scale < 1)
            {
                viewer.transform = viewer.transform.scaledBy(x: gesture.scale, y: gesture.scale)
                gesture.scale = 1
            }
        }
    }
    
    /*
     Controls movement for the map and booths within a specified range
     */
    func pan(gesture: UIPanGestureRecognizer)
    {
        let translation = gesture.translation(in: self.view)
        if let viewer = gesture.view
        {
            if !(viewer.frame.maxX + translation.x < frameMinimum || viewer.frame.minX + translation.x > self.view.frame.width - frameMinimum || viewer.frame.maxY + translation.y < frameMinimum || viewer.frame.minY + translation.y > self.view.frame.height - frameMinimum)
            {
                viewer.center = CGPoint.init(x: viewer.center.x + translation.x, y: viewer.center.y + translation.y)
                gesture.setTranslation(CGPoint.init(x: 0, y: 0), in: self.view)
            }
        }
    }
    
    /*
     Toggles on and off interaction with the map
    */
    func tap(gesture: UITapGestureRecognizer)
    {

        if(shapeSelected == true)
        {
            shapeSelected = false
            createBooth(gesture.location(in: self.mapImage), "circle")
        }
        else
        {
        }
    }
    
    func testButton(gesture: UITapGestureRecognizer)
    {
        shapeSelected = true
    }
    
    /*
    Creates a booth
    */
    func createBooth(_ point: CGPoint, _ shape: String)
    {
        let newButton: BoothShape = BoothShape.init(point, CGSize.init(width: 50, height: 50), shape, "white")
        newButton.name = "Default Name"
        newButton.info = "Default Info"
        newButton.date = ""
        newButton.draw(mapImage.bounds)

        //add function for button programatially
        //newButton.button.addTarget(self, action: #selector(popoverFromBoothMethod), for: .touchUpInside)
        buttons.append(newButton)
        mapImage.addSubview(newButton.button)
        
        
        
    }
    
    func popoverFromBoothMethod (sender: AnyObject)
    {
        let castedSender : BoothShape = sender as! BoothShape

            //print(sender.name)
            /* This is the line of code that calls the 'prepareforSegue' method,but we are not using it */
            //performSegue(withIdentifier: "editBoothPopover", sender: sender)
            //print(castedSender.name + " Here!")
    
        

            let rootVC = UIApplication.shared.keyWindow?.rootViewController

                //print(NSStringFromClass(rootVC!.classForCoder))

        
            //let strBoard = UIStoryboard(name: "Main", bundle: nil)
            let popoverController = rootVC!.storyboard!.instantiateViewController(withIdentifier: "editBoothViewController") as! EditBoothViewController
 
        
            //get a reference to the view controller for the popover
            popoverController.boothRef = castedSender //as? BoothShape
            popoverController.name = castedSender.name
            popoverController.info = castedSender.info
            popoverController.date = castedSender.date
            popoverController.boothImages = castedSender.boothPhotos
            popoverController.delegate = self
            
            // set the presentation style
            popoverController.modalPresentationStyle = UIModalPresentationStyle.popover
            
            // set up the popover presentation controller
            popoverController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
            //popController?.preferredContentSize = CGSize(width:300, height: 300)
            //popController?.preferredContentSize = CGSize(width: UIScreen.main.nativeBounds.size.width*0.5,height:UIScreen.main.nativeBounds.size.height*0.5)
            //UIScreen.main.nativeBounds.size * 0.5
            popoverController.popoverPresentationController?.delegate = self
            popoverController.popoverPresentationController?.sourceView = castedSender.button //as? UIView
            // set anchor programatically
            popoverController.popoverPresentationController?.sourceRect = castedSender.button.bounds
            
            // present the popover
            self.present(popoverController, animated: true, completion: nil)
        
    }
    
//    //if remove this then, iphone will show popover as a full page
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return UIModalPresentationStyle.none
//    }

    
    
}

    

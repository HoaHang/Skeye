//
//  EditBoothViewController.swift
//  Maps
//
//  Created by yoho chen on 11/4/16.
//  Copyright © 2016 Team_Interactive_Maps. All rights reserved.
//
//  DatePicker Tutorial: www.youtube.com/watch?v=_ADJxJ7pjRk
//
//  Thanks Icons8.com for camera icon. link: icons8.com/web-app/11772/Screenshot-Filled
import UIKit

/* Delegate Comment: Declare Protocal and method signature in the children/sender/delegating/ class */

protocol DataSentDelegate {
    func userDidEditName(data:String, whichBooth: BoothShape)
    func userDidEditInfo(data:String, whichBooth: BoothShape)
    func userDidEditDate(data:String, whichBooth: BoothShape)
    func userDidUploadPic(data:[UIImage], whichBooth: BoothShape)
    
}

class EditBoothViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {

/* Delegate Comment: instantiate an protocal object in this class, when u segue way in from the
     parentVC, set "this.delegate = parentVC.self" */

    var delegate: DataSentDelegate? = nil;
    var boothRef :BoothShape? = nil
    var name = ""
    var info = ""
    var date = ""
    var boothImages:[UIImage] = []
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boothName.text = name
        boothInfo.text = info
        boothDate.text = date
        
        //set no photo label
        if(boothImages.count>0){
            noPhotoLabel.isHidden = true
            
        }
        boothInfo.layer.cornerRadius = 5.0

//       // boothInfo.layer.shadowColor = UIColor.black.cgColor
//        boothInfo.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        boothInfo.layer.shadowOpacity = 1.0
//        boothInfo.layer.shadowRadius = 2.0
       
   
       
        
        createDatePicker()
        loadImages()
    }
    
    @IBOutlet weak var datePickerTxt: UITextField!
    
    @IBOutlet weak var boothName: UITextField!
    
    @IBOutlet weak var boothInfo: UITextView!
    
    @IBOutlet weak var boothDate: UITextField!
    
    @IBOutlet weak var noPhotoLabel: UILabel!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = UIColor.black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    @IBAction func AddImage(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.view.tintColor = UIColor.black
        let camButton = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (libSelected) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let libButton = UIAlertAction(title: "Choose from Album", style: UIAlertActionStyle.default) { (libSelected) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            (libSelected) in
            
        }
        actionSheet.addAction(camButton)
        actionSheet.addAction(libButton)
        actionSheet.addAction(cancelButton)
        self.present(actionSheet, animated: true, completion: nil)
    
    }
    
    //after choosing the image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        //imageDisplay.contentMode = .scaleAspectFill
       // imageDisplay.image = chosenImage
        boothImages.append(chosenImage)
        loadImages()//for fun
        
        //hide no photo label
//        if imageDisplay.image != nil
//        {
//            self.noPhotoLabel.isHidden = true
//        }
        dismiss(animated:true, completion: nil)
    }
    
    
    /* Date Picker */
    func createDatePicker(){
        
        //datePicker.datePickerMode = .date
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDonePressed))
        toolbar.setItems([doneButton], animated: false)
        
        datePickerTxt.inputAccessoryView = toolbar
        
        //assigning date picker to textfield
        datePickerTxt.inputView = datePicker
    }
    
    //load ImageArray into the scroll view
    func loadImages(){

        for i in 0..<boothImages.count{
            
            let imageView = UIImageView()
            //reverse order so that newest pic in front
            imageView.image = boothImages[boothImages.count-i-1]
            imageView.contentMode = .scaleAspectFill
            imageView.isUserInteractionEnabled = true
            
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: self.view.frame.origin.y, width: self.imageScrollView.frame.width, height: self.imageScrollView.frame.height)
            
            let longPressImage = UILongPressGestureRecognizer(target: self, action: #selector(deleteImage))
            imageView.addGestureRecognizer(longPressImage)
            
            imageScrollView.contentSize.width = imageScrollView.frame.width * CGFloat(i + 1)
            imageScrollView.addSubview(imageView)
            
        }
    }
    
    
    func deleteImage(sender: UIGestureRecognizer){

        // if long press on user
        if sender.state == UIGestureRecognizerState.began {
      
            let alertController = UIAlertController(title: "Delete this photo?", message: nil , preferredStyle: .alert)

            //cancel button
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                alertController.dismiss(animated: true, completion: nil)
            }
            
            //delete button
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                //get the current page on scrollView
                let page = Int(self.imageScrollView.contentOffset.x / self.imageScrollView.frame.size.width);
                
                //remove from array
                self.boothImages.remove(at: self.boothImages.count - page - 1)
                
                //remove all subview (inefficient but work)
                for view in self.imageScrollView.subviews{
                    if view .isKind(of: UIImageView.self) {
                        view.removeFromSuperview()
                    }
                }
                //reload
                self.loadImages()
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true)
            
           
            
        }
        
 
    }
    
    func dateDonePressed(){
        
        // formate date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        //datePickerTxt.text = "\(datePicker.date)" //without formatting
        datePickerTxt.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
        
    
//    //inorder to save/share photo
//    func saveshare(){
//        let myMessage = "Hello world"
//        let activityVC = UIActivityViewController(activityItems: [myMessage], applicationActivities: nil)
//        self.present(activityVC, animated: true, completion: nil)
//    }
    
    
    // Done button clicked
    
    @IBAction func DoneBtnPressed(_ sender: UIButton) {
        if delegate != nil
        {
            // check name change
            if boothName.text != name
            {
                if let newName = boothName.text
                {
                    delegate?.userDidEditName(data: newName, whichBooth: boothRef!)
                }
                else{
                    print("null value for name")
                }
                
            }
            
            // check info change
            if boothInfo.text != info
            {
                if let newInfo = boothInfo.text
                {
                    delegate?.userDidEditInfo (data: newInfo, whichBooth: boothRef!)
                }
                else{
                    print("null value for info")
                }
                
            }
            
            // check date change
            if boothDate.text != date
            {
                if let newDate = boothDate.text
                {
                    delegate?.userDidEditDate (data: newDate, whichBooth: boothRef!)
                }
                else{
                    print("null value for date")
                }
                
            }
            
            //save photo
            if (1==1) //IF UPLOADED photo, add boolean later
            {
                delegate?.userDidUploadPic(data: boothImages, whichBooth:boothRef!)
                
            }
            
            self.presentingViewController!.dismiss(animated: false, completion: nil) //To dismiss popover
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        if delegate != nil
        {
            /*
                method to prompt the user exith withtou saving
            */
           self.presentingViewController!.dismiss(animated: false, completion: nil) //To dismiss popover
        }
    }

    
    

    
    // To dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
}














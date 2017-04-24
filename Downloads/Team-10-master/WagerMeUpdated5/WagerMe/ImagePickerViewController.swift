//
//  ImagePickerViewController.swift
//  WagerMe
//
//  Created by steven poulos on 4/18/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
//CODED BY STEVEN POULOS
// FOLLOWED TUTORIAL FROM Sergey Kargopolov
//Complete Login and Registration System in PHP and MYSQL. (2017, April 18). Retrieved April 20, 2017,
//  from https://www.udemy.com/login-and-registration-system-in-php-and-mysql-step-by-step/

import UIKit

class ImagePickerViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    
    //checks if there is no profile image, the pull it from the cgi pub
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let username = UserDefaults.standard.string(forKey: "userUsername")!
        usernameLabel.text = username
        
        
        
        // this sets the image view to your image when you log in searching the db for a picture that corressponfsd to your id
        if(profilePhotoImageView.image == nil)
        {
            
            let userId = UserDefaults.standard.string(forKey: "id")
            
            let imageUrl = URL(string:"https://cgi.soic.indiana.edu/~team10/profile-pictures/\(userId!)/user-profile.jpg")
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            
                
                let imageData = try? Data(contentsOf: imageUrl!)
                
                
                if(imageData != nil)
                {
                    DispatchQueue.main.async(execute: {
                        self.profilePhotoImageView.image = UIImage(data: imageData!)
                    })
                }
                
            }
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // this is the action when the button is tapped, user is prompted to select from library
    //import UIKit
    //import GoogleMobileAds
    //
    //class PhotoSelectorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //
    //    @IBOutlet weak var bannerView: GADBannerView!
    //
    //    @IBOutlet weak var myImageView: UIImageView!
    //
    //    @IBAction func importImage(_ sender: Any)
    //
    //
    //    {
    //        let image = UIImagePickerController()
    //        image.delegate = self
    //
    //        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
    //
    //        image.allowsEditing = false
    //
    //        self.present(image, animated: true)
    //        {
    //            //After it is complete
    //        }
    //    }

    @IBAction func importImage(_ sender: AnyObject) {
        let myImagePicker = UIImagePickerController()
       
        
        myImagePicker.delegate = self
        
        
        myImagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        
        self.present(myImagePicker, animated: true, completion: nil)
    }
    // this is the action when the button is tapped, user is prompted to select from camera
    @IBAction func TakePhoto(_ sender: AnyObject) {
        
        
        let myImagePicker = UIImagePickerController()
        myImagePicker.delegate = self
        
        myImagePicker.sourceType = UIImagePickerControllerSourceType.camera
        
        myImagePicker.allowsEditing = false
        
        self.present(myImagePicker, animated: true)
        {
        }
    }
    
    ////    @IBAction func TakePhoto(_ sender: AnyObject) {
    ////        let image = UIImagePickerController()
    ////        image.delegate = self
    ////
    ////        image.sourceType = UIImagePickerControllerSourceType.camera
    ////
    ////        image.allowsEditing = false
    ////
    ////        self.present(image, animated: true)
    ////        {
    ////            //After it is complete
    ////        }
    ////    }
    //
    ////    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    ////    {
    ////        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
    ////        {
    ////            myImageView.image = image
    ////        }
    ////        else
    ////        {
    ////            //Error message
    ////        }
    ////        
    ////        self.dismiss(animated: true, completion: nil)
    ////    }
    ////    

    
    
    // after the image selection or taking is done it assigns it to the image view and gets it ready for upload
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        profilePhotoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        myImageUploadRequest()
    }
    
    //this is the uploading part, it takes the php where it is being stored and then posts the image information and such to the php which is stored in a file in the cgi pub inside another file that is represented by the users id
    func myImageUploadRequest()
    {
        let myUrl = URL(string: "https://cgi.soic.indiana.edu/~team10/imageUpload.php");
        
        
        var request = URLRequest(url:myUrl!);
        
        request.httpMethod = "POST";
        
        
        let userId:String? = UserDefaults.standard.string(forKey: "id")
        
        //we set up parameters and boundaries for the image so it is sent properly
        
        let param = ["userId" : userId!]
        
        
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //this is the jpeg representation of the image data.
        
        let imageData = UIImageJPEGRepresentation(profilePhotoImageView.image!, 1)
        
        
        if(imageData==nil)  { return; }
        
        
        request.httpBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            DispatchQueue.main.async
                {
        
            }
            
        
            if error != nil {
                
                return
            }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                DispatchQueue.main.async
                    
                    {
                        
                        if let parseJSON = json {
                    
                            //displays an alert if something goes wrong.
                            let userMessage = parseJSON["message"] as? String
                            
                            self.displayAlertMessage(userMessage!)
                        } else {
                            // Display an alert message
                            let userMessage = "Could not upload image at this time"
                            self.displayAlertMessage(userMessage)
                        }
                }
            } catch
            {
                print(error)
            }
            
            
        }
        
        task.resume()
        
        
        
    }
    
    ////    @IBAction func SaveButton(_ sender: Any)
    ////
    ////
    ////    {
    ////
    ////
    ////
    ////        let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team10/savePhoto.php")! as URL)
    ////        request.httpMethod = "POST"
    ////
    ////        let postString = "a=\(String(describing: myImageView.image))"
    ////
    ////        request.httpBody = postString.data(using: String.Encoding.utf8)
    ////
    ////        let task = URLSession.shared.dataTask(with: request as URLRequest) {
    ////            data, response, error in
    ////
    ////            if error != nil {
    ////                print("error=\(String(describing: error))")
    ////                return
    ////            }
    ////
    ////            print("response = \(String(describing: response))")
    ////
    ////            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
    ////            print("responseString = \(String(describing: responseString))")
    ////        }
    ////        task.resume()
    ////
    ////        //Alert for successful registration
    ////
    ////        let alertController = UIAlertController(title: "User", message: "Picture Sucessfully Saved", preferredStyle: UIAlertControllerStyle.alert)
    ////        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    ////
    ////        self.present(alertController, animated: true, completion: nil)
    ////
    ////    }
    ////
    ////    override func viewDidLoad() {
    ////        super.viewDidLoad()
    ////
    ////        // Do any additional setup after loading the view.
    ////
    ////        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PhotoSelectorViewController.dismissKeyboard))
    ////
    ////        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
    ////        //tap.cancelsTouchesInView = false
    ////
    ////        view.addGestureRecognizer(tap)
    ////        // Do any additional setup after loading the view, typically from a nib.
    ////
    ////
    ////        /// The banner view.
    ////        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
    ////        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
    ////        bannerView.rootViewController = self
    ////        bannerView.load(GADRequest())
    ////    }
    ////
    ////    override func didReceiveMemoryWarning() {
    ////        super.didReceiveMemoryWarning()
    ////        // Dispose of any resources that can be recreated.
    ////    }
    ////
    ////    //Calls this function when the tap is recognized.
    ////    func dismissKeyboard() {
    ////        //Causes the view (or one of its embedded text fields) to resign the first responder status.
    ////        view.endEditing(true)
    ////    }
    ////
    ////    
    ////    
    ////}

    
    
    
    // another function that is used to set parameters and the body wehn used to upload the image.
    func createBodyWithParameters(_ parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary:
        String) -> Data {
        
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        
        
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        
        body.append(imageDataKey)
        
        
        
        body.appendString("\r\n")
        
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body as Data
    }
    
    
    func generateBoundaryString() -> String {
        // Create and return a unique string.
        return "Boundary-\(UUID().uuidString)"
    }
    //displays an alert when things work correctly
    func displayAlertMessage(_ userMessage:String)
    {
       
        let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
        
        
        
        myAlert.addAction(okAction);
        
        
        self.present(myAlert, animated: true, completion: nil)
        
    }
    
    
}



extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

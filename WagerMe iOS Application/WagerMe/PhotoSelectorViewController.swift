//
////
////  PhotoSelectorViewController.swift
////  WagerMe
////
////  Created by steven poulos on 3/9/17.
////  Copyright © 2017 Christopher calvert. All rights reserved.
//// CODED BY STEVEN POULOS
////Complete Login and Registration System in PHP and MYSQL. (2017, April 18). Retrieved April 20, 2017,
////  from https://www.udemy.com/login-and-registration-system-in-php-and-mysql-step-by-step/
//
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
//    
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
////   
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

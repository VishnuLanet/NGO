//
//  ViewController.swift
//  NGO
//
//  Created by lanet on 17/01/18.
//  Copyright © 2018 Vishnu. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleSignIn
import FBSDKLoginKit

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

//    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var bgImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().signOut()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // let img:UIImage=UIImage(named: "login2.png")!
        
        // Google
        GIDSignIn.sharedInstance().clientID = "689426819497-kge5sc1uv1tq1m9cq1a4okaukdj5eqvt.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
         
        let btnLogin:FBSDKLoginButton=FBSDKLoginButton()
        btnLogin.center=self.view.center
        btnLogin.readPermissions = ["public_profile", "email"]
//        self.view.addSubview(btnLogin)
        
        
        // Check Facebook Login or not
        
//        if let accessToken = FBSDKAccessToken.current() {
//            // User is logged in, use 'accessToken' here.
//
//            print(accessToken.permissions)
//
//            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: accessToken.tokenString, version: nil, httpMethod: "GET")
//            req?.start(completionHandler: { (connection, result, error : Error!) -> Void in
//                if(error == nil)
//                {
//                    print("result \(result)")
//                }
//                else
//                {
//                    print("error \(error)")
//                }
//            })
//        }
        
        
        /*
            Arjun
        var error : NSError?
         
        //setting the error
        GGLContext.sharedInstance().configureWithError(&error)
        
        GIDSignIn.sharedInstance().clientID = "689426819497-kge5sc1uv1tq1m9cq1a4okaukdj5eqvt.apps.googleusercontent.com"
        
        //if any error stop execution and print error
        if error != nil{
            print(error ?? "google error")
            return
        }
        */
        
        bgImgView.image=resize(resize(UIImage(named: "login2.png")!, compression: 0.1), compression: 1.0)
        
        if !CheckInternet.isConnectedToNetwork(){
            let alert=UIAlertController.init(title: "Internet Problem", message: "Please, Check Internet Connection", preferredStyle: UIAlertControllerStyle.actionSheet)
            alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    /*
        Google Code
     
    // Implement these methods only if the GIDSignInUIDelegate is not a subclass of
    // UIViewController.
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
//        myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func resize(_ image: UIImage, compression : Float) -> UIImage {
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = actualHeight
        let maxWidth: Float = actualWidth
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = compression
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!, CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        let myImg=UIImage(data: imageData!)!
        print("compares : ", (imageData?.count)!/1024)
        return myImg
    }
    
    

    @IBAction func btnDrag(_ sender: Any) {
        do
        {
            let loginManager=FBSDKLoginManager()
            loginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (res, error1) in
                if(error1==nil)
                {
                    let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: res?.token.tokenString, version: nil, httpMethod: "GET")
                    req?.start(completionHandler: { (connection, result, error2 : Error!) -> Void in
                        if(error2 == nil)
                        {
                            print("result \(result)")
                            let userDef=UserDefaults.standard.set(true, forKey: "Login")
                            self.performSegue(withIdentifier: "segueGotoHome", sender: nil)
                        }
                        else
                        {
                            print("error \(error2)")
                        }
                    })
                }
            }
        }
        catch let err as NSError
        {
            print(err)
        }
    }
    @IBAction func btnFacebook(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "Login")
        self.performSegue(withIdentifier: "segueGotoHome", sender: nil)
        
        
//        GIDSignIn.sharedInstance().signIn()
        
//        if #available(iOS 10.0, *) {
//            //iOS 10 or above version
//            let center = UNUserNotificationCenter.current()
//            let content = UNMutableNotificationContent()
//            content.title = "Late wake up call"
//            content.body = "The early bird catches the worm, but the second mouse gets the cheese."
//            content.categoryIdentifier = "alarm"
//            content.userInfo = ["customData": "fizzbuzz"]
//            content.sound = UNNotificationSound.default()
//
//            var dateComponents = DateComponents()
//            dateComponents.hour = 12
//            dateComponents.minute = 17
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//            center.add(request)
//        } else {
//            // ios 9
//            let notification = UILocalNotification()
//            notification.fireDate = NSDate(timeIntervalSinceNow: 5) as Date
//            notification.alertBody = "Hey you! Yeah you! Swipe to unlock!"
//            notification.alertAction = "be awesome!"
//            notification.soundName = UILocalNotificationDefaultSoundName
//
//            UIApplication.shared.scheduleLocalNotification(notification)
//
//            let notification1 = UILocalNotification()
//            notification1.fireDate = NSDate(timeIntervalSinceNow: 10) as Date
//            notification1.alertBody = "Hey you! Yeah you! Swipe to unlock!"
//            notification1.alertAction = "be awesome!"
//            notification1.soundName = UILocalNotificationDefaultSoundName
//
//            UIApplication.shared.scheduleLocalNotification(notification1)
//
//        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if(error == nil)
        {
            print(user.profile.email)
            UserDefaults.standard.set(true, forKey: "Login")
            self.performSegue(withIdentifier: "segueGotoHome", sender: nil)
        }
        else
        {
            print(error)
        }
    }
    
    @IBAction func btnGoogle(_ sender: Any) {
        if CheckInternet.isConnectedToNetwork()
        {
            GIDSignIn.sharedInstance().signIn()
            // self.performSegue(withIdentifier: "segueGotoHome", sender: nil)
        }
        else
        {
            let alert=UIAlertController.init(title: "Internet Problem", message: "Please, Check Internet Connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

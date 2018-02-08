//
//  AppDelegate.swift
//  
//
//  Created by lanet on 01/02/18.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        // Google
//        GIDSignIn.sharedInstance().clientID = "689426819497-kge5sc1uv1tq1m9cq1a4okaukdj5eqvt.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance().delegate = self
      
        //Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        // push notification
//        registerForPushNotifications()
        
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        let defaults=UserDefaults.standard
        let nav=UINavigationController()
        nav.setNavigationBarHidden(true, animated:true)

        if(defaults.object(forKey: "Login") == nil)
        {
            self.window?.rootViewController=nav
            nav.pushViewController(storyBoard.instantiateViewController(withIdentifier: "Login"), animated: true)
        }
        else
        {
            self.window?.rootViewController=nav
            nav.pushViewController(storyBoard.instantiateViewController(withIdentifier: "Home"), animated: true)
        }

        return true
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    
// Notification in 10.0*
//    func registerForPushNotifications() {
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
//                (granted, error) in
//                print("Permission granted: \(granted)")
//
//                guard granted else { return }
//                self.getNotificationSettings()
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//
//    func getNotificationSettings() {
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
//                print("Notification settings: \(settings)")
//                guard settings.authorizationStatus == .authorized else { return }
//                DispatchQueue.main.sync {
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//
//    func application(_ application: UIApplication,
//                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let tokenParts = deviceToken.map { data -> String in
//            return String(format: "%02.2hhx", data)
//        }
//
//        let token = tokenParts.joined()
//        print("Device Token: \(token)")
//    }
//
//    func application(_ application: UIApplication,
//                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register: \(error)")
//    }
    
    
    
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        // Google
        var options: [String: AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                            UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation!]
        print("URL :- \(url)")
        print("sourceApplication :- \(String(describing: sourceApplication))")
        
        // Facebook
//        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
        
        // Google
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

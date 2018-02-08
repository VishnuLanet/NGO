//
//  HomeVC.swift
//  NGO
//
//  Created by lanet on 17/01/18.
//  Copyright © 2018 Vishnu. All rights reserved.
//

import UIKit
import CoreLocation

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var locationView: UIView!
    
    var arr: NSMutableArray = [], serArr: NSArray = []
    var menuFlag=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let str=Bundle.main.path(forResource: "data", ofType: "plist")
//        arr=NSArray.init(contentsOfFile: str!)!

        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(locationManagerSetting))
        locationView.addGestureRecognizer(tapGesture)
        
//        JSONGoogle()
//        JSONphp()
        
        tblView.register(UINib.init(nibName: "RestoTVC", bundle: nil), forCellReuseIdentifier: "myCell")
        
        let left=UISwipeGestureRecognizer.init(target: self, action: #selector(leftSwap))
        left.direction=UISwipeGestureRecognizerDirection.left
        tblView.addGestureRecognizer(left)
        
        let right=UISwipeGestureRecognizer.init(target: self, action: #selector(rightSwap))
        right.direction=UISwipeGestureRecognizerDirection.right
        tblView.addGestureRecognizer(right)
        viewMenu.addGestureRecognizer(left)
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "Login")
        self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "Login"))!, animated: true)
    }
    
    @objc func locationManagerSetting()
    {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No Access")
                if !CLLocationManager.locationServicesEnabled() {
                    if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                        // If general location settings are disabled then open general location settings
                        UIApplication.shared.openURL(url)
                    }
                } else {
                    if let url = URL(string: UIApplicationOpenSettingsURLString) {
                        // If general location settings are enabled then open location settings for the app
                        UIApplication.shared.openURL(url)
                    }
                }
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
    }

//    var timer=Timer()
    func getLocation()
    {
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        
        var currentLocation: CLLocation?
     
        let queue = DispatchQueue.global(qos: .background)
        queue.async(execute: {() -> Void in
//            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.chkContinueConnection), userInfo: nil, repeats: true)
            
            locManager.requestWhenInUseAuthorization()
            while(currentLocation == nil)
            {
                if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized) {
                    currentLocation = locManager.location
                }
                
//                currentLocation?.coordinate.latitude=21.14711
//                currentLocation?.coordinate.longitude=72.760305
            }
            DispatchQueue.main.async {
                self.locationView.isHidden=true
                self.JSONGoogle(currentLocation: currentLocation!)
            }
        })
        
    }
    
    
    func JSONGoogle(currentLocation:CLLocation)
    {
//        timer.invalidate()
        
        let url=URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)&radius=5000&keyword=restaurants&key=AIzaSyCdY4xaVV4IRreBmPKqt0h1Jgq4qREKJOc")
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            do
            {
                let googleMap : NSDictionary=try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary //allowfragment
                // For Img = https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=&key=AIzaSyCdY4xaVV4IRreBmPKqt0h1Jgq4qREKJOc
                
                for tmpDict in googleMap["results"] as! NSArray
                {
//                    let tmpDict=(googleMap["results"] as! NSArray)[0]
                    var myDict : [String : Any] = [String : Any]()
                    
                    myDict["lat"]=(((tmpDict as! NSDictionary)["geometry"] as! NSDictionary)["location"] as! NSDictionary)["lat"] as! CLLocationDegrees
                    myDict["lng"]=(((tmpDict as! NSDictionary)["geometry"] as! NSDictionary)["location"] as! NSDictionary)["lng"] as! CLLocationDegrees
                    
                    let coordinate₀ = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                    let coordinate₁ = CLLocation(latitude: (((tmpDict as! NSDictionary)["geometry"] as! NSDictionary)["location"] as! NSDictionary)["lat"] as! CLLocationDegrees, longitude: (((tmpDict as! NSDictionary)["geometry"] as! NSDictionary)["location"] as! NSDictionary)["lng"] as! CLLocationDegrees)
                    
                    myDict["Distance"]=String(format: "%.1f", coordinate₀.distance(from: coordinate₁)/1000)
                    myDict["place_id"]=(tmpDict as! NSDictionary)["place_id"] as! String
                    myDict["name"]=(tmpDict as! NSDictionary)["name"] as! String
                    
                    if(((tmpDict as! NSDictionary)["photos"]) != nil)
                    {
                        myDict["img"]=(((tmpDict as! NSDictionary)["photos"] as! NSArray)[0] as! NSDictionary)["photo_reference"] as? String
                    }
                    else
                    {
                        myDict["img"]="Empty"
                    }
                    myDict["Address"]=(tmpDict as! NSDictionary)["vicinity"] as! String
//                    myDict["types"]=(tmpDict as! NSDictionary)["types"] as! NSArray
                    if((myDict["rating"]) != nil)
                    {
                        myDict["rating"]=(tmpDict as! NSDictionary)["rating"] as! Float
                    }
                    else
                    {
                         myDict["rating"]=0.0
                    }
                    
                    self.arr.add(myDict)
                }
                DispatchQueue.main.async
                {
                    self.tblView.reloadData()
                    self.loadingView.isHidden=true
                    
                    for view in self.loadingView.subviews {
                        view.isHidden=true
                    }
                }
//                print(googleMap["results"])
            }
            catch let err as NSError
            {
                print(err)
            }
        }.resume()
    }
    
    
    // For my php api
    func JSONphp()
    {
        let url=URL(string: "https://vishnumavawala.000webhostapp.com/lanet/iOS/restoDetails.php")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if(error==nil)
            {
                DispatchQueue.main.async
                    {
                        do
                        {
                            let myjson=try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                            self.arr=myjson.mutableCopy() as! NSMutableArray
                            self.tblView.reloadData()
                            self.loadingView.isHidden=true
                            
                            for view in self.loadingView.subviews {
                                view.isHidden=true
                            }
                        }
                        catch let myError as NSError
                        {
                            print(myError)
                        }
                }
            }
        }.resume()
    }
    
    @objc func leftSwap()
    {
        if(menuFlag)
        {
            UIView.animate(withDuration: 0.25, animations: {
                if(UIDevice.current.userInterfaceIdiom == .pad)
                {
                    self.viewMenu.frame.origin.x-=500
                }
                else
                {
                    self.viewMenu.frame.origin.x-=240
                }
            })
            menuFlag=false
        }
    }
    
    @objc func rightSwap()
    {
        if(!menuFlag)
        {
            UIView.animate(withDuration: 0.25, animations: {
                if(UIDevice.current.userInterfaceIdiom == .pad)
                {
                    self.viewMenu.frame.origin.x+=500
                }
                else
                {
                    self.viewMenu.frame.origin.x+=240
                }
            })
            menuFlag=true
        }
    }
    
    @IBAction func btnMenu(_ sender: Any)
    {
        UIView.animate(withDuration: 0.25, animations: {
            if(UIDevice.current.userInterfaceIdiom == .pad)
            {
                self.viewMenu.frame.origin.x+=500
            }
            else
            {
                self.viewMenu.frame.origin.x+=240
            }
            self.menuFlag=true
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getLocation()
        
        
//        let request=URLRequest.init(url: url!)
//        do
//        {
//            let response:AutoreleasingUnsafeMutablePointer<URLResponse?>
//            let data : Data=try NSURLConnection.sendSynchronousRequest(request, returning: response)
//
//            print(data)
//            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { (response, data, error) in
//                let myjson=try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
//                print(myjson)
//            }
//        }
//        catch let myerror as NSError
//        {
//            print(myerror)
//        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      print(searchText)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let myDict=arr[indexPath.row] as! NSDictionary
        self.performSegue(withIdentifier: "segueMenu", sender: myDict)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc2 : MenuVC=segue.destination as! MenuVC
        vc2.resto=sender as! [String : Any]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
     // for iPad TableViewCell Size
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            return 325
        }
        return 177
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell : RestoTVC = tableView.dequeueReusableCell(withIdentifier: "myCell") as! RestoTVC
        
        let myDict=arr[indexPath.row] as! NSDictionary
        
        myCell.lblName.text=myDict["name"] as? String
//        self.LoadImage(catPictureURL: (myDict["img"] as! String), ImageView: myCell.imgName)
        myCell.lblHint.text="Food"//(myDict["types"] as! Array).joined(separator: " | ") as! String
        
        let sq = DispatchQueue.global(qos: .default)
        sq.async(execute: {() -> Void in
            
            let img=self.downloadImage(str: (myDict["img"] as! String))
            DispatchQueue.main.async {
                myCell.imgName.image=img
            }
        })
        
//        myCell.lblHint.text=myDict["hint"] as? String
        return myCell
    }
    
    func downloadImage(str : String) -> UIImage
    {
        var img : UIImage?=nil
        do
        {
            let fileMgr=FileManager.default
            print("\(NSTemporaryDirectory())\(str)")
            if(str=="Empty")
            {
                img=UIImage(named: "Empty.jpg")
            }
            else if(!fileMgr.fileExists(atPath: "\(NSTemporaryDirectory())\(str)"))
            {
                if CheckInternet.isConnectedToNetwork(){
                    let url : URL=URL.init(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(str)&key=AIzaSyCdY4xaVV4IRreBmPKqt0h1Jgq4qREKJOc")!
                    let data :Data? = try Data.init(contentsOf: url)
                    img=UIImage(data: data!)

                    let tmpURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                        .appendingPathComponent(str)
                    print("Filepath: \(tmpURL)")

                    do{
                        try data?.write(to: tmpURL)
                    }
                    catch let err as NSError
                    {
                        print(err)
                    }
                }
                
//                img=UIImage(named: "Empty.jpg")
            }
            else
            {
//                if(str.compare("Empty")==ComparisonResult.orderedSame)
                img=UIImage.init(contentsOfFile: "\(NSTemporaryDirectory())\(str)")
                print("Filepath: \(NSTemporaryDirectory())")
            }
        }
        catch let err as NSError
        {
            print(err)
        }
        return img!
    }
    func LoadImage(catPictureURL : String, ImageView imageview:UIImageView) -> Void {
        let session = URLSession.shared
        let url = URL(string: catPictureURL)!
        let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        DispatchQueue.main.async {
                            let image = UIImage(data: imageData)
                            imageview.image = image
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

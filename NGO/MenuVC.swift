//
//  MenuVC.swift
//  NGO
//
//  Created by lanet on 18/01/18.
//  Copyright © 2018 Vishnu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MenuVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var resto : [String : Any] = [String : Any]()
    var reviewArr : NSArray = []
    var arr : NSArray = []
    var urlResto : String = ""
    
    @IBOutlet weak var tblReview: UITableView!
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var lblRasto: UILabel!
    @IBOutlet weak var lblHead: UILabel!
//    @IBOutlet weak var lblClose: UIButton!
    @IBOutlet weak var lblRestoAddress: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lbl11: UIButton!
    @IBOutlet weak var lbl12: UIButton!
    @IBOutlet weak var lbl13: UIButton!
    @IBOutlet weak var lbl14: UIButton!
    
    @IBOutlet weak var lblOpen: UIButton!
    
    // All View
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var AboutView: UIView!
    @IBOutlet weak var reviewView: UIView!
    
    var totalRating:Float = 0.0
    func getRestoDetails()
    {
        
//        Get Review for place_id
//        https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJ0X80NgdS4DsRseAP2IrDzKw&key=AIzaSyCdY4xaVV4IRreBmPKqt0h1Jgq4qREKJOc
        
        let url=URL.init(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(resto["place_id"] as! String)&key=AIzaSyCdY4xaVV4IRreBmPKqt0h1Jgq4qREKJOc")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do
            {
                var dt=try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                dt=(dt["result"] as! NSDictionary)
                if((dt["reviews"]) != nil)
                {
                    self.reviewArr=dt["reviews"] as! NSArray
                }
                if((dt["rating"]) != nil)
                {
                    self.totalRating=dt["rating"] as! Float
                }
                else
                {
                    self.totalRating=0.0
                }
                if(dt["website"] != nil)
                {
                    self.urlResto=dt["website"] as! String
                }
                DispatchQueue.main.async {
                    self.tblReview.reloadData()
                }
            }
            catch let err
            {
                print(err)
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArr.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row==0)
        {
            return 204
        }
        return 120
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // tableView.register(UINib.init(nibName: "ReviewTblViewCell", bundle: nil), forCellReuseIdentifier: "ProtoContent")
        
        if(indexPath.row==0)
        {
            let myCell=tableView.dequeueReusableCell(withIdentifier: "protoHead") as! ReviewHeadTVC
            
            myCell.lblTotalReview.text=String(reviewArr.count) + " Reviews"
            myCell.lblTotalRating.text=String(totalRating)
            myCell.setStar(i: totalRating)
            return myCell
        }
        else
        {
            let myCell=tableView.dequeueReusableCell(withIdentifier: "protoContent") as! ReviewTVC
            
            let myDict=reviewArr[indexPath.row-1] as! NSDictionary
            
            myCell.lblUserName.text=myDict["author_name"] as? String
            myCell.lblDescript.text=myDict["text"] as? String
            
            let milisecond = (myDict["time"] as! Double)
            let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(milisecond)/1000)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
            myCell.lblTime.text=dateFormatter.string(from: dateVar)
            
            myCell.setStar(i: (myDict["rating"] as? Float)!)
            
            return myCell
        }
    }
    
    @IBAction func btnOpen(_ sender: Any) {
        if(urlResto != "")
        {
            self.performSegue(withIdentifier: "segueGotoURL", sender: urlResto)
        }
        else
        {
            let alert=UIAlertController(title: "Not Available URL", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webVC=segue.destination as! WebViewVC
        webVC.str=urlResto
    }
    @IBAction func changeView(_ sender: Any) {
        let i=(sender as! UISegmentedControl).selectedSegmentIndex
        if(i==0)
        {
            menuView.isHidden=false
            for view in menuView.subviews {
                view.isHidden=false
            }
            AboutView.isHidden=true
            for view in AboutView.subviews {
                view.isHidden=true
            }
            reviewView.isHidden=true
            for view in reviewView.subviews {
                view.isHidden=true
            }
        }
        else if(i==1)
        {
            menuView.isHidden=true
            for view in menuView.subviews {
                view.isHidden=true
            }
            AboutView.isHidden=false
            for view in AboutView.subviews {
                view.isHidden=false
            }
            reviewView.isHidden=true
            for view in reviewView.subviews {
                view.isHidden=true
            }
        }
        else if(i==2)
        {
            menuView.isHidden=true
            for view in menuView.subviews {
                view.isHidden=true
            }
            AboutView.isHidden=true
            for view in AboutView.subviews {
                view.isHidden=true
            }
            reviewView.isHidden=false
            for view in reviewView.subviews {
                view.isHidden=false
            }
        }
    }
    
    
//    @IBAction func btnOpen(_ sender: Any)
//    {
//        for view in menuView.subviews {
//            view.removeFromSuperview()
//        }
//    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var currCollection=1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callCollection()
        
        lblOpen.layer.cornerRadius = 9
        
        lblHead.text = resto["name"] as? String
        lblRasto.text = resto["name"] as? String
        lblDistance.text=(resto["Distance"] as? String)! + "km away"
        
        mapView.delegate=self
        
        swapInit()
        mapInit()
        getRestoDetails()
        
        menuView.isHidden=false
        for view in menuView.subviews {
            view.isHidden=false
        }
        AboutView.isHidden=true
        for view in AboutView.subviews {
            view.isHidden=true
        }
        reviewView.isHidden=true
        for view in reviewView.subviews {
            view.isHidden=true
        }
        
//        lblClose.contentEdgeInsets = UIEdgeInsets(top: 44, left: 0, bottom: 44, right: 44)
    }
    
    func swapInit()
    {
        let left=UISwipeGestureRecognizer.init(target: self, action: #selector(leftSwap))
        left.direction=UISwipeGestureRecognizerDirection.left
        collectionView.addGestureRecognizer(left)
        
        let right=UISwipeGestureRecognizer.init(target: self, action: #selector(rightSwap))
        right.direction=UISwipeGestureRecognizerDirection.right
        collectionView.addGestureRecognizer(right)
    }
    
    func mapInit()
    {
        // Arjun
        let location=CLLocation(latitude:51.5033640, longitude:0.1276250)
        let center=MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
        mapView.setRegion(center, animated: true)
        mapView.showsUserLocation=true
        
        // Vishnu
//        let location1=MKPointAnnotation()
//        location1.coordinate=CLLocationCoordinate2DMake(51.5033640, 0.1276250)
//        location1.title=restoName
//
//        mapView.addAnnotation(location)
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn11(_ sender: Any) {
        currCollection=1
        callCollection();
    }
    @IBAction func btn12(_ sender: Any) {
        currCollection=2
        callCollection()
    }
    @IBAction func btn13(_ sender: Any) {
        currCollection=3
        callCollection()
    }
    @IBAction func btn14(_ sender: Any) {
        currCollection=4
        callCollection()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib.init(nibName: "MenuCVC", bundle: nil), forCellWithReuseIdentifier: "myCell")
        let myCell=collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MenuCVC

        let myDict = arr[indexPath.row] as! NSDictionary
        
        
        DispatchQueue.global(qos: .default).async {
            self.downloadImage(str: myDict["img"] as! String, img: myCell.imgShow)
        }
        
        myCell.lblName.text=(myDict["name"] as! String)
        myCell.lblPrice.text="₹" + String(describing: myDict["price"] as! Int)
        return myCell
    }
    
    func downloadImage(str : String, img : UIImageView) -> Void {
        do
        {
            print(str)
            let url:URL?=URL.init(string:str)
            let data=try Data.init(contentsOf: url!)
            DispatchQueue.main.async {
                img.image=UIImage(data: data)
            }
        }
        catch let err as NSError
        {
            print(err)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 12 * 3) / 3 //some width
        let height = width * 0.9 //ratio
        return CGSize(width: width, height: height);
    }
    
    @objc func rightSwap()
    {
        currCollection-=1;
        if(currCollection==0)
        {
            currCollection=4
        }
        callCollection()
    }
    
    @objc func leftSwap()
    {
        currCollection+=1;
        if(currCollection==5)
        {
            currCollection=1
        }
        callCollection()
    }
    
    func callCollection()
    {
//        var str : String=""
        
        if(currCollection==1)
        {
            lbl11.setTitleColor(UIColor.orange, for: UIControlState.normal);
            lbl12.setTitleColor(UIColor.darkGray, for: UIControlState.normal);
            lbl13.setTitleColor(UIColor.darkGray, for: UIControlState.normal);
            lbl14.setTitleColor(UIColor.darkGray, for: UIControlState.normal);
            
//            str=Bundle.main.path(forResource: "Main", ofType: "plist")!
        }
        else if(currCollection==2)
        {
            lbl11.setTitleColor(UIColor.darkGray, for: UIControlState.normal);
            lbl12.setTitleColor(UIColor.orange, for: UIControlState.normal);
            lbl13.setTitleColor(UIColor.darkGray, for: UIControlState.normal);
            lbl14.setTitleColor(UIColor.darkGray, for: UIControlState.normal);
            
//            str=Bundle.main.path(forResource: "Appetizeers", ofType: "plist")!
        }
        else if(currCollection==3)
        {
            lbl11.setTitleColor(UIColor.darkGray, for: UIControlState.normal);
            lbl12.setTitleColor(UIColor.darkGray, for: UIControlState.normal);
            lbl13.setTitleColor(UIColor.orange, for: UIControlState.normal);
            lbl14.setTitleColor(UIColor.darkGray, for: UIControlState.normal);
            
//            str=Bundle.main.path(forResource: "Desserts", ofType: "plist")!
        }
        else if(currCollection==4)
        {
            lbl11.setTitleColor(UIColor.darkGray, for: UIControlState.normal);
            lbl12.setTitleColor(UIColor.darkGray, for: UIControlState.normal);
            lbl13.setTitleColor(UIColor.darkGray, for: UIControlState.normal);
            lbl14.setTitleColor(UIColor.orange, for: UIControlState.normal);
            
//            str=Bundle.main.path(forResource: "Soup", ofType: "plist")!
        }
//        arr=NSArray.init(contentsOfFile: str)!
        
        do
        {
            let url=URL(string: "https://vishnumavawala.000webhostapp.com/lanet/iOS/menuDetails.php")
            var request = URLRequest.init(url: url!)
            let myDict : [String: Int] = ["info" : currCollection]
            let dat : Data=try JSONSerialization.data(withJSONObject: myDict, options: [])
            request.httpBody=dat
            URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                do {
                    self.arr = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSArray
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch let error as NSError {
                    print(error)
                }
            }).resume()
        }
        catch let ex as NSError
        {
            print(ex)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

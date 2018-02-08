//
//  WebViewVC.swift
//  NGO
//
//  Created by lanet on 02/02/18.
//  Copyright © 2018 Vishnu. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var str : String? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: str!);
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnClose(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
}

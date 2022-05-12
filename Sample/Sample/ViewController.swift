//
//  ViewController.swift
//  WKBridgeKit
//
//  Created by Samse on 2022/04/25
//

import UIKit
import WKBridgeKit

class ViewController: BridgeWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadUrl(URL.init(string: "https://www.google.com"))
        self.dismissSplash()
    }


}


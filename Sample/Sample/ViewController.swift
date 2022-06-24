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
//        (UIApplication.shared.delegate as? AppDelegate)?.setStatusBarColor(.red)

        // Do any additional setup after loading the view.
//        let urlPath = Bundle.main.path(forResource: "sample", ofType: "html")
//        let url = NSURL.fileURL(withPath: urlPath!)
//        self.loadUrl(url)
        self.loadUrl(URL(string: "https://www.ntoworks.com/app/nbridge/v2/sample.html"))
        self.dismissSplash()
    }


}


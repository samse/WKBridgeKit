//
//  ViewController.swift
//  WKBridgeKit
//
//  Created by Samse on 2022/04/25
//

import UIKit
import WKBridgeKit

class ViewController: BridgeWebViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var orientation: UIInterfaceOrientationMask = .portrait

    override func viewDidLoad() {
        super.viewDidLoad()
//        (UIApplication.shared.delegate as? AppDelegate)?.setStatusBarColor(.red)

        // Do any additional setup after loading the view.
//        let urlPath = Bundle.main.path(forResource: "sample", ofType: "html")
//        let url = NSURL.fileURL(withPath: urlPath!)
//        self.loadUrl(url)
        self.loadUrl(URL(string: "https://www.ntoworks.com/app/nbridge/v2/sample.html"))
        self.dismissSplash()
        
//        if (@available(macOS 13.3, iOS 16.4, tvOS 16.4, *)){
////            self.webView!.inspectable = true
//            
//        }
        if #available(iOS 16.4, *) {
            self.webView?.isInspectable = true
        } else {
            // Fallback on earlier versions
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.setOrientation(.landscapeLeft)
//        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.orientation
    }

    override var shouldAutorotate: Bool {
        return true
    }

    func setOrientation(_ orientation: UIInterfaceOrientation) {
        /// 3. 설정하려는 방향을 체크하고 해당 값에 대응되는 값 들을 설정하도록 합니다.
        if orientation == .portrait {
            /// 3-1. appDelegate의 orientations 변수의 값을 변경하여
            /// Device 전체가 지원하는 orientation을 변경합니다.
            self.appDelegate.orientations = [.portrait]
            /// 3-2. 해당 viewController에서 지원하는 orientation을 변경합니다.
            self.orientation = .portrait
            /// 3-3. 현재 Device의 orientation값을 변경합니다.
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        } else
        if orientation == .landscapeLeft {
            self.appDelegate.orientations = [.landscapeLeft]
            self.orientation = .landscapeLeft
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        }
    }

}


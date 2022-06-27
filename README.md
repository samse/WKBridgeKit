# WKBridgeKit

WKBridgeKit is Smiple Web-Native bridge library

Usage
------
```
import WKBridgeKit

class ViewController: BridgeWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadUrl(URL.init(string: "https://www.daum.net"))
        self.dismissSplash()
    }
```

Swift Package Manager (SPM)
---------------------------
The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler. To integrate using Apple's Swift package manager from xcode :

File -> Swift Packages -> Add Package Dependency...

Enter package URL : https://github.com/samse/WKBridgeKit


License
--------
This code is distributed under the terms and conditions of the MIT license.

Sample
--------
https://apps.apple.com/us/app/nbridge/id1628984500

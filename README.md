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

License
--------
This code is distributed under the terms and conditions of the MIT license.




//
//  BridgeWebViewController.swift
//  WKBridgeKit
//
//  Created by Samse on 2022/04/25
//

import Foundation
import UIKit
import WebKit

open class BridgeWebViewController : UIViewController {
    open var pluginManager: PluginManager?
    open var webView: WKWebView?
    open var url: URL?
    open var pendedUrl: URL? // 웹뷰가 준비되기 전에 저장될 URL
    
    open var isReady = false // 웹뷰 준비 상태
    open var isPortrait = true   // 화면 방향 FLAG
    open var processPool: WKProcessPool?
    
    public let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        initPlugins()
        initNotifications()
        presentSplash()
    }

    open func initViews() {
        processPool = WKProcessPool()
        
        let webConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(self, name: "WKBridge")    // nbridge 등록

        webConfiguration.processPool = processPool!
        webConfiguration.userContentController = contentController
        webConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = true
        webView = WKWebView(frame: view.frame, configuration: webConfiguration)

        webView?.allowsLinkPreview = false
        webView?.scrollView.minimumZoomScale = 1.0
        #if DEBUG
        webView?.allowsBackForwardNavigationGestures = true
        #endif
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadWebView(_:)), for: .valueChanged)
        webView?.scrollView.addSubview(refreshControl)
        
        view.addSubview(webView!)
        self.view.sendSubviewToBack(webView!)
        
        if #available(iOS 11.0, *) {
            let safeArea = self.view.safeAreaLayoutGuide
            webView?.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                webView!.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                webView!.topAnchor.constraint(equalTo: safeArea.topAnchor),
                webView!.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                webView!.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
            ])
        }
        loadUrl()

        webView?.uiDelegate = self
        webView?.navigationDelegate = self

    }
    
    @objc func reloadWebView(_ sender: UIRefreshControl) {
       webView?.reload()
       sender.endRefreshing()
   }
    
    /// add Plugins
    open func initPlugins() {
        pluginManager = PluginManager()
        pluginManager?.addPlugin(service: "app", plugin: AppPlugin(service: "app", viewController: self))
        pluginManager?.addPlugin(service: "preference", plugin: PreferencePlugin(service: "preference", viewController: self))
        pluginManager?.addPlugin(service: "location", plugin: GeoLocationPlugin(service: "location", viewController: self))
    }
    
    /// init lifecycle notifications
    open func initNotifications() {
        NotificationCenter.default.addObserver(self, selector:#selector(onResume), name:UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(onPause), name:UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    /// load specified url
    /// - Parameter targetUrl: URL to load
    open func loadUrl(_ targetUrl: URL? = nil) {
        guard let url = targetUrl else {
            if let url = self.url {
                self.webView?.load(URLRequest(url: url))
            }
            return
        }
        self.webView?.load(URLRequest(url: url))
    }
    
    /// load pending URL
    open func loadPendedUrl() {
        if let url = pendedUrl {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.loadUrl(url)
            }
            pendedUrl = nil
        }
    }
    
    /// verify URL
    /// - Returns: URL String
    open func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    /// show splash screen
    open func presentSplash() {
            if let launchView = launchScreen?.view {
                view?.addSubview(launchView)
            }
        }
    
    /// close splash screen
    open func dismissSplash() {
        if let launchView = launchScreen?.view {
            launchView.removeFromSuperview()
        }
    }
    
    /// load error page when failed loading page
    open func loadErrorPage() {
        onBridgeReady()
    }
    
    ///
    open func changeOrientation() {
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if isPortrait == true {
            return .portrait
        }
        return .landscapeRight
    }

    open override var shouldAutorotate: Bool {
        return true
    }
}

extension BridgeWebViewController {
    @objc func onPause() {
        let js = "nbridge.callPauseListener()"
        evaluateJavaScript(js)
    }
    
    @objc func onResume() {
        let js = "nbridge.callResumeListener()"
        evaluateJavaScript(js)
    }
    
    /// call javascript to WKWebView
    /// - Parameter js: script to call
    @objc open func evaluateJavaScript(_ js: String) {
        DispatchQueue.main.async {
            self.webView?.evaluateJavaScript(js)
        }
    }
}

//MARK : BridgeWebResultProtocol
extension BridgeWebViewController {
    func onBridgeReady() {
        guard isReady == false else { return }

        isReady = true
        dismissSplash()
        
        loadPendedUrl()
    }
    
    func onPromiseResolve(promiseId: String, result: String?) {
        let js = "nbridge.resolvePromise(\"\(promiseId)\", \(result ?? "{}"), null);"
        evaluateJavaScript(js)
    }
    
    func onPromiseFinallyResolve(promiseId: String, result: String?) {
        let js = "nbridge.finallyResolvePromise(\"\(promiseId)\", \(result ?? "{}"), null);"
        evaluateJavaScript(js)
    }
    
    func onPromiseReject(promiseId: String, result: String?) {
        let js = "nbridge.resolvePromise(\"\(promiseId)\", \(result ?? "{}"), {});"
        evaluateJavaScript(js)
    }
}

//MARK: WKNavigationDelegate
extension BridgeWebViewController:  WKNavigationDelegate {
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let request = navigationAction.request
        // 스토어 이동
        guard let url = request.url?.absoluteString,
              !url.contains("apps.apple.com"),
              !url.contains("itunes.apple.com") else {
                #if targetEnvironment(simulator)
                  Logger.debug("simulator is not supported")
                #else
                  UIApplication.shared.open(request.url!)
                #endif
                  decisionHandler(.cancel)
                  return
              }
        decisionHandler(.allow)
    }
    
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if (error as NSError).code == NSURLErrorNotConnectedToInternet {
            self.loadErrorPage()
        }
    }
    
    /// prevent duplicated reload
    open func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard webView == self.webView else {
            return
        }
    }
    
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
}

//MARK: WKUIDelegate
extension BridgeWebViewController: WKUIDelegate {
    
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            completionHandler()
        }
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
    
    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .default) { action in
            completionHandler(false)
        })
        alert.addAction(UIAlertAction(title: "confirm", style: .default) { action in
            completionHandler(true)
        })
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: WKScriptMessageHandler
extension BridgeWebViewController: WKScriptMessageHandler {
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let source = message.name
        if source == "WKBridge" {
            let body: String = message.body as! String
            let data = body.data(using: .utf8)
            
            do {
                let command: [String : Any] = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as! [String : Any]
                if JSONSerialization.isValidJSONObject(command) {
                    if let cmd = command["command"] as? String {
                        if cmd == "onBridgeReady" {
                            self.onBridgeReady()
                        }
                    }
                    if let service = command[PluginBase.SERVICE] as? String {
                        if let plugin = pluginManager?.findPlugin(service: service) {
                            plugin.execute(command: command)
                        } else {
                            if let promiseId = command[PluginBase.PROMISEID] as? String {
                                PluginBase(service: "PluginBase", viewController: self).invalidServiceError(promiseId)
                            }
                        }
                    }
                }
            } catch let error as NSError {
            }
        }
    }
}

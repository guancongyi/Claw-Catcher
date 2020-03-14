//
//  WebViewController.swift
//  Clawer
//
//  Created by Bowen on 12/3/18.
//  Copyright © 2018 Bowen. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    /*
     --------------------------------
     MARK: - Definitions of Constants
     --------------------------------
     */
    
    var qrCodeValue = ""
    let backButtonBlueImage     = UIImage(named: "BackBlueArrow")
    let backButtonGrayImage     = UIImage(named: "BackGrayArrow")
    let forwardButtonBlueImage  = UIImage(named: "ForwardBlueArrow")
    let forwardButtonGrayImage  = UIImage(named: "ForwardGrayArrow")
    
    /*
     --------------------------
     MARK: - Instance Variables
     --------------------------
     */
    
    // Instance Variables holding the object references of the UI objects created in the Storyboard
    @IBOutlet var backButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var urlTextField: UITextField!
    @IBOutlet var webView: WKWebView!
    
    /*
     --------------------------------------------------
     MARK: - Instance Methods Invoked by the UI Objects
     --------------------------------------------------
     */
    
    // This method is invoked when the user taps the back button
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        // Ask the web view object to invoke its goBack() method
        webView.goBack()
    }
    
    // This method is invoked when the user taps the forward button
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        
        // Ask the web view object to invoke its goForward() method
        webView.goForward()
    }
    
    // This method is invoked when the user taps the Go key on the keyboard
    @IBAction func keyboardDone(_ sender: UITextField) {
        
        // When the Text Field resigns as first responder, the keyboard is automatically removed.
        sender.resignFirstResponder()
        
        // Assign the URL text entered by the user into a constant string called enteredURL
        let enteredURL = sender.text
        
        // Declare an optional local variable of type URL
        var requestedURL: URL?
        
        if enteredURL!.hasPrefix("http") {
            /*
             Create an Instance of the URL Structure, initialize it with enteredURL,
             and store its unique ID into the local variable "requestedURL".
             */
            requestedURL = URL(string: enteredURL!)
            
        } else {
            // enteredURL does not start with "http" or "https".
            // So add "https://" to the beginning of enteredURL
            
            /*
             Create an Instance of the URL Structure, initialize it with "https://" + enteredURL,
             and store its unique ID into the local variable "requestedURL".
             */
            requestedURL = URL(string: "https://" + enteredURL!)
        }
        
        /*
         URLRequest is a Swift Structure!
         
         Create an Instance of the URLRequest Structure, initialize it with the "requestedURL"
         local variable value, and store its unique ID into the local constant "request".
         */
        let request = URLRequest(url: requestedURL!)
        
        // Ask the webView object to load the web page for the requested URL
        webView.load(request)
    }
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad() {
        /*
         Set self (UIViewController object) to be the webView (WKWebView) object's navigation delegate
         so that we can implement the three WKNavigationDelegate protocol methods given below.
         */
        webView.navigationDelegate = self
        
        // When the view loads, the webView object is asked to show the default homepage
        
        /*
         URL is a Swift Structure! (not a class!)
         
         "A URL is a Swift [Structure] type that can potentially contain the location of
         a resource on a remote server, the path of a local file on disk, ..." [Apple]
         
         Create an Instance of the URL Structure, initialize it with "https://www.cnn.com",
         and store its unique ID into the local constant "defaultURL".
         */
        
        let defaultURL = URL(string: qrCodeValue)
        
        /*
         URLRequest is a Swift Structure! (not a class!)
         
         Create an Instance of the URLRequest Structure, initialize it with the "defaultURL"
         local constant value, and store its unique ID into the local constant "requestedURL".
         */
        
        let requestedURL = URLRequest(url: defaultURL!)
        
        // Ask the webView object to load the web page for the requested URL
        webView.load(requestedURL)
        
        // Tell the super class to continue with the viewDidLoad method execution
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     -----------------------------------------------
     MARK: - Set Color of the Back or Forward Button
     -----------------------------------------------
     */
    
    // This function is called to set the colors of the back and forward navigation buttons
    func setColorsOfNavigationButtons() {
        
        // Display the back button in blue color if a previous web page exists.
        // Otherwise, display it in gray color.
        
        if webView.canGoBack {
            backButton.setImage(backButtonBlueImage, for: UIControl.State())
        } else {
            backButton.setImage(backButtonGrayImage, for: UIControl.State())
        }
        
        // Display the forward button in blue color if a forward web page exists.
        // Otherwise, display it in gray color.
        
        if webView.canGoForward {
            forwardButton.setImage(forwardButtonBlueImage, for: UIControl.State())
        } else {
            forwardButton.setImage(forwardButtonGrayImage, for: UIControl.State())
        }
    }
    
    /*
     ---------------------------------------------
     MARK: - WKNavigationDelegate Protocol Methods
     ---------------------------------------------
     */
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Starting to load the web page. Show the animated activity indicator in the status bar
        // to indicate to the user that the UIWebVIew object is busy loading the web page.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Finished loading the web page. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // Display the URL of the loaded web page in the URL text field
        urlTextField.text = self.webView.url?.absoluteString
        
        // Call this function to set the colors of the back and forward buttons
        setColorsOfNavigationButtons()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        /*
         Ignore this error if the page is instantly redirected via JavaScript or in another way.
         NSURLErrorCancelled is returned when an asynchronous load is cancelled, which happens
         when the page is instantly redirected via JavaScript or in another way.
         */
        
        if (error as NSError).code == NSURLErrorCancelled  {
            return
        }
        
        // Call this function to set the colors of the back and forward buttons
        setColorsOfNavigationButtons()
        
        // An error occurred during the web page load. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // Create the error message in HTML as a character string and store it into the local constant errorString
        let errorString = "<html><font size=+4 color='red'><p>Unable to Display Webpage: <br />Possible Causes:<br />- No network connection<br />- Wrong URL entered<br />- Server computer is down</p></font></html>" + error.localizedDescription
        
        // Display the error message within the webView object
        self.webView.loadHTMLString(errorString, baseURL: nil)
    }
    
}

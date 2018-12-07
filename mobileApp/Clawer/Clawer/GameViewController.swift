//
//  GameViewController.swift
//  Clawer
//
//  Created by Bowen on 12/1/18.
//  Copyright © 2018 Bowen. All rights reserved.
//



// 1. auto switch
// 2. change icon


import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var gameStatusTextView: UITextView!
    var HTMLString:String = ""
    var timer = Timer()
    var totalTime = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            //gameStatusTextView.text = String(timer.value(forKey: <#T##String#>))
        //status()
        
        
    }
    
    @objc func updateTimer() {
        status()
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            timer.invalidate()
        }
    }
    
    func status () {
        let URLString = "http://172.29.30.120/status"
        let URLLink = URL(string: URLString)
        do {
            HTMLString = try String(contentsOf: URLLink!, encoding: .ascii)
            
        }
        catch {
            gameStatusTextView.text = "No Status"
//            showAlertMessage(messageHeader: "Signal Unrecognized!", messageBody: "Cannot recongize return data!")
//            return
        }
        
        switch HTMLString {
        case "caught":
            gameStatusTextView.text = "Caught!"
        case "uncaught":
            gameStatusTextView.text = "Uncaught!"
        default:
            gameStatusTextView.text = "Catching!"
        }
        
        
    }
    
    /*
     -----------------------------
     MARK: - Display Alert Message
     -----------------------------
     */
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertController.Style.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

}

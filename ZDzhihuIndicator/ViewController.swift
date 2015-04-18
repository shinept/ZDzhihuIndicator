//
//  ViewController.swift
//  ZDzhihuIndicator
//
//  Created by 张亚东 on 15/3/29.
//  Copyright (c) 2015年 blurryssky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }
    @IBAction func respondsToButton(sender: UIButton) {
        let alertAction = UIAlertAction(title: "不错", style: UIAlertActionStyle.Default) { (_) -> Void in
            
        }
        
        let alertController = UIAlertController(title: "touch me", message: "转完才能点哦", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(alertAction)
        
        presentViewController(alertController, animated: true) { () -> Void in
            ZDzhihuIndicator.show()
            
            let t = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * NSEC_PER_SEC))
            dispatch_after(t, dispatch_get_main_queue()) { () -> Void in
                ZDzhihuIndicator.dismiss()
            }
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


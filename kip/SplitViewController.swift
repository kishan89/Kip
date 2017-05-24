//
//  SplitViewController.swift
//  kip
//
//  Created by Kishan Patel on 2/8/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .allVisible
        //self.preferredContentSize = CGSize(width: 5, height: self.accessibilityFrame.height);
        
        //self.preferredPrimaryColumnWidthFraction = 0.1
        // Do any additional setup after loading the view.
        
        
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        // Return YES to prevent UIKit from applying its default behavior
        return true
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

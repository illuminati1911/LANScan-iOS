//
//  DeviceViewController.swift
//  LANScan
//
//  Created by Ville Välimaa on 18/02/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import UIKit

class DeviceViewController: UIViewController {

    var host:Host?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
        // Do any additional setup after loading the view.
    }
    
    convenience init(host:Host) {
        self.init()
        self.host = host
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

//
//  MainViewController.swift
//  TestApp
//
//  Created by Ville Välimaa on 17/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import ReactiveCocoa

class MainViewController: UIViewController {

    var scanViewController:ScanViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.02, green:0.43, blue:0.56, alpha:1.0)
        
        self.scanViewController = ScanViewController()
        self.view.addSubview(self.scanViewController.view)
        self.addChildViewController(self.scanViewController)
        
        makeConstraints()
    }

    func makeConstraints(){
        

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

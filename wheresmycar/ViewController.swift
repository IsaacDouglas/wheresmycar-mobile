//
//  ViewController.swift
//  wheresmycar
//
//  Created by Isaac Douglas on 01/12/18.
//  Copyright © 2018 Isaac Douglas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let qrButton = UIButton(type: .custom)
        qrButton.setTitle("QRCODE", for: .normal)
        qrButton.setTitleColor(qrButton.tintColor, for: .normal)
        qrButton.addTarget(self, action: #selector(self.camAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: qrButton)
        
    }
    
    @objc func camAction(){
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "CamViewController") as! CamViewController
        let aObjNavi = UINavigationController(rootViewController: objVC)
        self.present(aObjNavi, animated: true, completion: nil)
    }

}


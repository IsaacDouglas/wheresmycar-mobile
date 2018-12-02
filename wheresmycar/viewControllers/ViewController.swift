//
//  ViewController.swift
//  wheresmycar
//
//  Created by Isaac Douglas on 01/12/18.
//  Copyright © 2018 Isaac Douglas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var labelSection: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.labelSection.text = ""
        
//        let qrButton = UIButton(type: .custom)
//        qrButton.setTitle("QRCODE", for: .normal)
//        qrButton.setTitleColor(qrButton.tintColor, for: .normal)
//        qrButton.addTarget(self, action: #selector(self.camAction), for: .touchUpInside)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: qrButton)
//
//        let mapButton = UIButton(type: .custom)
//        mapButton.setTitle("MAPA", for: .normal)
//        mapButton.setTitleColor(mapButton.tintColor, for: .normal)
//        mapButton.addTarget(self, action: #selector(self.mapAction), for: .touchUpInside)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mapButton)
        
        centerView.layer.cornerRadius = centerView.frame.width / 2
        centerView.layer.shadowOffset = CGSize(width: 5, height: 5)
        centerView.layer.shadowRadius = 10
        centerView.layer.shadowOpacity = 0.5
        
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.5
        
        self.navigationItem.title = "Where's my car?"
    }
    
    @IBAction func lerAction(_ sender: Any) {
        self.labelSection.text = ""
        self.camAction()
    }
    
    @objc func camAction(){
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "CamViewController") as! CamViewController
        objVC.delegate = self
        let aObjNavi = UINavigationController(rootViewController: objVC)
        self.present(aObjNavi, animated: true, completion: nil)
    }
    
    @objc func mapAction(){
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let aObjNavi = UINavigationController(rootViewController: objVC)
        self.present(aObjNavi, animated: true, completion: nil)
    }

    func getJson(token: String){
        let url = "http://ec2-54-69-43-225.us-west-2.compute.amazonaws.com:8080/api/card?token=\(token)"
        Util().getRequest(url: url, by: { data in
            let decoder = JSONDecoder()
            let _card = try! decoder.decode([Card].self, from: data)
            
            self.labelSection.text = _card[0].section.code
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let datas = try! encoder.encode(_card)
            print(String(data: datas, encoding: .utf8)!)
        })
    }
}

extension ViewController: StreamDelegate {
    
    func sendString(text: String) {
        self.getJson(token: text)
    }
}


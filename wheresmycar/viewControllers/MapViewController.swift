//
//  MapViewController.swift
//  wheresmycar
//
//  Created by Isaac Douglas on 02/12/18.
//  Copyright © 2018 Isaac Douglas. All rights reserved.
//

import UIKit
import CoreLocation
import SpriteKit
import GameplayKit

class MapViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var skView: SKView!
    var locationManager: CLLocationManager!
    var scene: SKScene!
    
    var list: [CGPoint] = []
    var cicleList: [SKShapeNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let backbutton = UIButton(type: .custom)
        backbutton.setTitle("Voltar", for: .normal)
        backbutton.setTitleColor(backbutton.tintColor, for: .normal)
        backbutton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        
        self.navigationItem.title = "Mapa"
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        self.scene = self.skView.scene!
        
        list.append(CGPoint(x: 100, y: 0))
        list.append(CGPoint(x: -100, y: 0))
        list.append(CGPoint(x: 0, y: 100 * sqrt(3)))
        
        
        let p1 = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 5, height: 5))
        p1.position = list[0]
        self.scene.addChild(p1)
        
        let p2 = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 5, height: 5))
        p2.position = list[1]
        self.scene.addChild(p2)
        
        let p3 = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 5, height: 5))
        p3.position = list[2]
        self.scene.addChild(p3)
        
        
        for i in list {
            let p = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 5, height: 5))
            p.position = i
            self.scene.addChild(p)
            
            let s = SKShapeNode(circleOfRadius: 10)
            s.strokeColor = UIColor.yellow
            s.position = i
            self.scene.addChild(s)
            self.cicleList.append(s)
        }
        
    }
    
    @objc func backAction() {
        let navigationController = self.presentingViewController as? UINavigationController
        self.dismiss(animated: true) {
            let _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func getDistance(rssi value : Int) -> Double {
        let rssi = -1 * value
        //        30 : 00
        //        60 : 0.5m
        //        70 : 1m
        //        90 : 2m
        return Double(rssi)
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "My Beacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        
        let uuid2 = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
        let beaconRegion2 = CLBeaconRegion(proximityUUID: uuid2, identifier: "My Beacon 2")
        
        locationManager.startMonitoring(for: beaconRegion2)
        locationManager.startRangingBeacons(in: beaconRegion2)
    }
    
    func getBeacon() {
        let url = "http://ec2-54-69-43-225.us-west-2.compute.amazonaws.com:8080/api/beacon"
        Util().getRequest(url: url, by: { data in
            let decoder = JSONDecoder()
            let beaconList = try! decoder.decode([Beacon].self, from: data)
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try! encoder.encode(beaconList)
            print(String(data: data, encoding: .utf8)!)
            
            for beacon in beaconList {
                let uuid = UUID(uuidString: beacon.uuid)!
                let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "My Beacon")
                
                self.locationManager.startMonitoring(for: beaconRegion)
                self.locationManager.startRangingBeacons(in: beaconRegion)
            }
        })
    }

}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            let be = Beacon()
            be.uuid = beacon.proximityUUID.uuidString
            be.major = Int(truncating: beacon.major)
            be.minor = Int(truncating: beacon.minor)
            be.rssi = beacon.rssi
            
            switch beacon.proximity {
            case .far:
                be.proximity = "far"
            case .immediate:
                be.proximity = "immediate"
            case .near:
                be.proximity = "near"
            default :
                be.proximity = "unknown"
            }
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try! encoder.encode(be)
            print(String(data: data, encoding: .utf8)!)
            
            self.label.text = "\(getDistance(rssi: be.rssi))"
        }
        
        
//        if beacons.count > 1 {
//            self.cicleList[2]
//        }else{
//            self.cicleList[2].run(SKAction.scale(to: Int(getDistance(rssi: beacons[0].rssi)), duration: 1))
//        }
        
    }
}

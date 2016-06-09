//
//  ViewController.swift
//  ALMANAC Water Management
//
//  Created by Thomas Gilbert on 28/05/16.
//  Copyright © 2016 Thomas Gilbert. All rights reserved.
//

import Cocoa
import MapKit
import Alamofire

class ViewController: NSViewController {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var regionPopup: NSPopUpButton!
    @IBOutlet weak var messageTextField: NSTextField!
    
    var turinCityAreas = [String:CityArea]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTurinCity()
        
        map.pitchEnabled = true
        
       // map.setRegion(turin, animated: true)
        
        regionPopup.setTitle("Select Region")
        regionPopup.pullsDown = false
        regionPopup.removeAllItems()
        
        for area in turinCityAreas {
            regionPopup.addItemWithTitle(area.0)
        }
        
        regionPopup.selectItemWithTitle("Entire City")
    }
    
    @IBAction func sendMessage(sender: NSButtonCell) {
        print("Send Message")
        print(map.centerCoordinate)
        print(map.region.span)
        
        let message = messageTextField.stringValue
        let region = regionPopup.selectedItem?.title

        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://watermeterofthefuture.servicebus.windows.net:443/almanac/messages")!)
        request.HTTPMethod = "POST"
        let postString = "{\"message\": \"\(region!) Alert - \(message)\",\"type\": \"LEAK\",\"count\": 1}"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let _ = [
            "ServiceBusNotification-Format": "template",
            "ServiceBusNotification-Apns-Expiry": "2017-07-16T19:20+01:00",
            "ServiceBusNotification-Tags": "ALMANAC",
            "Authorization": "SharedAccessSignature sr=https%3a%2f%2fwatermeterofthefuture.servicebus.windows.net%3a443%2falmanac%2fmessages&sig=Wn%2BhC5Kh6XEgcy7p2wo4y68XTBD5qHqqPT8NTzmaYGM%3D&se=1493298826&skn=RootManageSharedAccessKey",
            "Content-Type": "application/json;charset=utf-8"
        ]
        
        request.addValue("template", forHTTPHeaderField: "ServiceBusNotification-Format")
        request.addValue("2017-07-16T19:20+01:00", forHTTPHeaderField: "ServiceBusNotification-Apns-Expiry")
        request.addValue("ALMANAC", forHTTPHeaderField: "ServiceBusNotification-Tags")
        request.addValue("SharedAccessSignature sr=https%3a%2f%2fwatermeterofthefuture.servicebus.windows.net%3a443%2falmanac%2fmessages&sig=Wn%2BhC5Kh6XEgcy7p2wo4y68XTBD5qHqqPT8NTzmaYGM%3D&se=1493298826&skn=RootManageSharedAccessKey", forHTTPHeaderField: "Authorization")
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 201 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    @IBAction func changeThing(sender: NSPopUpButtonCell) {
        
        let item = sender.selectedItem?.title
        
        if let area = turinCityAreas[item!] {
            switch area {
            case .Area(let region):
                map.setRegion(region, animated: true)
            }
        }
        
        print("Thing Changed: \(item)")
    }
    
    func initTurinCity() {
        turinCityAreas["Entire City"] = CityArea.Area(MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 45.061, longitude: 7.656), span: MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        turinCityAreas["Borgo Vittoria"] = CityArea.Area(MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 45.100139330991119, longitude: 7.6799183745809696), span: MKCoordinateSpan.init(latitudeDelta: 0.02, longitudeDelta: 0.036)))
        turinCityAreas["Aurora"] = CityArea.Area(MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 45.061, longitude: 7.656), span: MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        turinCityAreas["Vanchiglia"] = CityArea.Area(MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 45.061, longitude: 7.656), span: MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)))
        turinCityAreas["San Salvario"] = CityArea.Area(MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 45.055324051404995, longitude: 7.6810352622968825), span: MKCoordinateSpan.init(latitudeDelta: 0.0080045761394487158, longitudeDelta: 0.014641764018705317)))
        turinCityAreas["San Rita"] = CityArea.Area(MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 45.061, longitude: 7.656), span: MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)))
        turinCityAreas["Mirafiori Nord"] = CityArea.Area(MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 45.061, longitude: 7.656), span: MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)))
        turinCityAreas["Mirafiori Sud"] = CityArea.Area(MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 45.061, longitude: 7.656), span: MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)))
        turinCityAreas["Tagliaferro"] = CityArea.Area(MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 45.068, longitude: 7.696), span: MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)))
        turinCityAreas["Regio Parco"] = CityArea.Area(MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 45.094660433419087, longitude: 7.7137263729651462), span: MKCoordinateSpan.init(latitudeDelta: 0.015109429169172017, longitudeDelta: 0.027656808738527161)))

    }
}

enum CityArea {
    case Area(MKCoordinateRegion)
}
//
//  MapKitViewController.swift
//  PercentageCalculator
//
//  Created by B1media on 2016/6/27.
//  Copyright © 2016年 App Coda. All rights reserved.


import UIKit
import MapKit
import AddressBook

class MapKitViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let initialLocation = CLLocation(latitude: 25.075118, longitude: 121.515799)
        centerMapOnLocation(locationManager.location!)
        
        let artwork = Artwork(title: "敦南",
                              locationName: "誠品書店",
                              discipline: "take a break",
                              coordinate: CLLocationCoordinate2D(latitude: 25.039489, longitude: 121.549328))
        
        loadInitialData()
        
        mapView.addAnnotations(artworks)
        mapView.addAnnotation(artwork)
        mapView.delegate = self
    }


    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    var artworks = [Artwork]()
    func loadInitialData() {
        // 1
        let fileName = NSBundle.mainBundle().pathForResource("PublicArt", ofType: "json");
        var readError : NSError?
        var data: NSData = try! NSData(contentsOfFile: fileName!, options: NSDataReadingOptions(rawValue: 0))
        
        // 2
        var error: NSError?
        let jsonObject: AnyObject!
        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(data,
                                                                    options: NSJSONReadingOptions(rawValue: 0))
        } catch var error1 as NSError {
            error = error1
            jsonObject = nil
        }
        
        // 3
        if let jsonObject = jsonObject as? [String: AnyObject] where error == nil,
            // 4
            let jsonData = JSONValue.fromObject(jsonObject)?["data"]?.array {
            for artworkJSON in jsonData {
                if let artworkJSON = artworkJSON.array,
                    // 5
                    artwork = Artwork.fromJSON(artworkJSON) {
                    artworks.append(artwork)
                }
            }
        }
    }
    

    // MARK: - location manager to authorize user location for Maps app
    
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
  
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
}

//
//  File.swift
//  
//
//  Created by 최지철 on 7/14/24.
//

import Foundation

import NMapsMap

public extension NMGLatLng {
    /// `NMGLatLng` -> `CLLocationCoordinate2D`
    var clCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}

public extension CLLocationCoordinate2D {
    /// `CLLocationCoordinate2D` -> `NMGLatLng`
    var nmLatLng: NMGLatLng {
        return NMGLatLng(lat: latitude, lng: longitude)
    }
}

public extension NMFCameraPosition {
    convenience init(_ target: CLLocationCoordinate2D) {
        self.init(target.nmLatLng, zoom: 16.5)
    }
}

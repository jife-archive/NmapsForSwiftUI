//
//  File.swift
//  
//
//  Created by 최지철 on 7/14/24.
//

import Foundation

import UIKit

import NMapsMap

public class NMFMapView: UIView {
    private var mapView: NMFMapView
    
    public override init(frame: CGRect) {
        self.mapView = NMFMapView(frame: frame)
        super.init(frame: frame)
        self.addSubview(mapView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

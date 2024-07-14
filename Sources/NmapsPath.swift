//
//  File.swift
//  
//
//  Created by 최지철 on 7/14/24.
//

import Foundation

import NMapsMap

public struct NaverMapPath {
    public enum LineStyle {
        case solid
        case dashed([NSNumber], NSNumber)
    }
    
    var width: CGFloat = 5
    var outlineWidth: CGFloat = 1
    
    var color: UIColor = .white
    var outlineColor: UIColor = .black
    
    var lineStyle: LineStyle = .solid
    
    public init() {}
    
    func makePath() -> NMFPath {
        return NMFPath()
    }
    
    func updatePath(_ path: NMFPath, coordinates: [CLLocationCoordinate2D], mapView: NMFMapView) {
        path.width = width
        path.outlineWidth = outlineWidth
        
        path.color = color
        path.outlineColor = outlineColor
        
        let points = coordinates.map { $0.nmLatLng }
        path.path = NMGLineString(points: points)
        
        switch lineStyle {
        case .solid:
            path.pattern = nil
        case .dashed(let pattern, let interval):
            path.pattern = pattern
            path.patternInterval = interval
        }
        
        path.mapView = mapView
    }
}
public extension NaverMapPath {
    func width(_ width: CGFloat) -> NaverMapPath {
        var new = self
        new.width = width
        return new
    }
    
    func outlineWidth(_ outlineWidth: CGFloat) -> NaverMapPath {
        var new = self
        new.outlineWidth = outlineWidth
        return new
    }
    
    func color(_ color: UIColor) -> NaverMapPath {
        var new = self
        new.color = color
        return new
    }
    
    func outlineColor(_ outlineColor: UIColor) -> NaverMapPath {
        var new = self
        new.outlineColor = outlineColor
        return new
    }
    
    func lineStyle(_ lineStyle: LineStyle) -> NaverMapPath {
        var new = self
        new.lineStyle = lineStyle
        return new
    }
}

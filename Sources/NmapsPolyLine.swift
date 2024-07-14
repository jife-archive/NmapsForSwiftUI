//
//  File.swift
//  
//
//  Created by 최지철 on 7/14/24.
//

import Foundation

import NMapsMap

public struct NaverMapPolyLine {
    public enum LineStyle {
        case solid
        case dot([NSNumber])
    }
    
    var width: CGFloat = 5
    var color: UIColor = .blue
    var lineStyle: LineStyle = .solid
    
    public init() {}
    
    func makePolyline(coordinates: [CLLocationCoordinate2D]) -> NMFPolylineOverlay {
        let points = coordinates.map { $0.nmLatLng }
        let polyline = NMFPolylineOverlay(points)
        polyline?.width = width
        polyline?.color = color
        
        switch lineStyle {
        case .solid:
           break
        case .dot(let pattern):
            polyline?.pattern = pattern
        }
        
        return polyline!
    }
}

public extension NaverMapPolyLine {
    func width(_ width: CGFloat) -> NaverMapPolyLine {
        var new = self
        new.width = width
        return new
    }
    
    func color(_ color: UIColor) -> NaverMapPolyLine {
        var new = self
        new.color = color
        return new
    }
    
    func lineStyle(_ lineStyle: LineStyle) -> NaverMapPolyLine {
        var new = self
        new.lineStyle = lineStyle
        return new
    }
}

//
//  NmapsView.swift
//  
//
//  Created by 최지철 on 7/14/24.
//

import SwiftUI
import NMapsMap

public struct NaverMap<MarkerItems>: UIViewRepresentable where MarkerItems: RandomAccessCollection, MarkerItems.Element: Identifiable {
    
    @Binding var cameraPosition: NMFCameraPosition
    @Binding var positionMode: NMFMyPositionMode
    
    var lineCoordinates = [CLLocationCoordinate2D]()
    var onMapTap: ((CLLocationCoordinate2D) -> Void)?
    var isRotateGestureEnabled = true
    var isTiltGestureEnabled = true
    
    var markerItems: MarkerItems
    var markerContent: ((MarkerItems.Element) -> NaverMapMarker)?
    var pathContent: () -> NaverMapPolyLine = { NaverMapPolyLine() }
    
    var logoAlign: NMFLogoAlign = .leftBottom
    var logoMargin: UIEdgeInsets = .zero
    
    public init(
        cameraPosition: Binding<NMFCameraPosition>,
        positionMode: Binding<NMFMyPositionMode> = .constant(.disabled),
        lineCoordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D](),
        markerItems: MarkerItems,
        markerContent: @escaping (MarkerItems.Element) -> NaverMapMarker
    ) {
        self._cameraPosition = cameraPosition
        self._positionMode = positionMode
        self.lineCoordinates = lineCoordinates
        self.markerItems = markerItems
        self.markerContent = markerContent
    }
    
    public func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()
        mapView.touchDelegate = context.coordinator
        mapView.addCameraDelegate(delegate: context.coordinator)
        mapView.addOptionDelegate(delegate: context.coordinator)
        mapView.moveCamera(NMFCameraUpdate(position: cameraPosition))
        return mapView
    }
    
    public func updateUIView(_ mapView: NMFMapView, context: Context) {
        updateOptions(mapView, coordinator: context.coordinator)
        updateCamera(mapView, coordinator: context.coordinator, animated: context.transaction.animation != nil)
        updateMarker(mapView, coordinator: context.coordinator)
        updatePath(mapView, coordinator: context.coordinator)
    }
    
    private func updateOptions(_ mapView: NMFMapView, coordinator: Coordinator) {
        guard !coordinator.updatingParentOptions else {
            coordinator.updatingParentOptions = false
            return
        }
        mapView.isRotateGestureEnabled = isRotateGestureEnabled
        mapView.isTiltGestureEnabled = isTiltGestureEnabled
        if mapView.positionMode != positionMode {
            mapView.positionMode = positionMode
        }
        mapView.logoAlign = logoAlign
        mapView.logoMargin = logoMargin
    }
    
    private func updateCamera(_ mapView: NMFMapView, coordinator: Coordinator, animated: Bool) {
        guard !coordinator.updatingCamera else { return }
        guard !coordinator.updatingParentCamera else {
            coordinator.updatingParentCamera = false
            return
        }
        guard mapView.cameraPosition != cameraPosition else { return }
        let cameraUpdate = NMFCameraUpdate(position: cameraPosition)
        if animated {
            cameraUpdate.animation = .easeIn
        }
        mapView.moveCamera(cameraUpdate)
    }
    
    private func updateMarker(_ mapView: NMFMapView, coordinator: Coordinator) {
        guard let markerContent = markerContent else {
            return
        }
        var ids: [AnyHashable] = Array(coordinator.markers.keys)
        for item in markerItems {
            let content = markerContent(item)
            if let index = ids.firstIndex(of: item.id) {
                guard let marker = coordinator.markers[item.id] else { fatalError() }
                content.updateMarker(marker, mapView)
                ids.remove(at: index)
            } else {
                let marker = content.makeMarker(mapView)
                content.updateMarker(marker, mapView)
                coordinator.markers[item.id] = marker
            }
        }
        for id in ids {
            coordinator.markers[id]?.mapView = nil
            coordinator.markers[id] = nil
        }
    }
    
    private func updatePath(_ mapView: NMFMapView, coordinator: Coordinator) {
        guard lineCoordinates.count > 1 else { return }
        let content = pathContent()
        let path = content.makePolyline(coordinates: lineCoordinates)
        path.mapView = mapView
        coordinator.path = path
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    public class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFMapViewOptionDelegate {
        var parent: NaverMap
        var markers = [AnyHashable: NMFMarker]()
        var path: NMFPolylineOverlay?
        
        var updatingParentOptions = false
        var updatingParentCamera = false
        var updatingCamera = false
        
        init(_ parent: NaverMap) {
            self.parent = parent
        }
        
        public func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
            parent.onMapTap?(latlng.clCoordinate)
        }
        
        public func mapViewCameraIdle(_ mapView: NMFMapView) {
            updatingCamera = false
            updatingParentCamera = true
            parent.cameraPosition = mapView.cameraPosition
        }
        
        public func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
            updatingCamera = true
            parent.cameraPosition = mapView.cameraPosition
        }
        
        public func mapViewOptionChanged(_ mapView: NMFMapView) {
            updatingParentOptions = true
            parent.positionMode = mapView.positionMode
        }
    }
}

public extension NaverMap {
    func onMapTap(perform action: @escaping (CLLocationCoordinate2D) -> Void) -> NaverMap {
        var new = self
        new.onMapTap = action
        return new
    }
    
    func pathStyle(_ content: @escaping () -> NaverMapPolyLine) -> NaverMap {
        var new = self
        new.pathContent = content
        return new
    }
    
    func rotateGestureEnabled(_ value: Bool) -> NaverMap {
        var new = self
        new.isRotateGestureEnabled = value
        return new
    }
    
    func tiltGestureEnabled(_ value: Bool) -> NaverMap {
        var new = self
        new.isTiltGestureEnabled = value
        return new
    }
    
    func logoAlign(_ align: NMFLogoAlign) -> NaverMap {
        var new = self
        new.logoAlign = align
        return new
    }
    
    func logoMargin(_ margin: UIEdgeInsets) -> NaverMap {
        var new = self
        new.logoMargin = margin
        return new
    }
}

public typealias _DefaultMarkerItems = [_DefaultMarkerItem]
public struct _DefaultMarkerItem: Identifiable {
    public var id = false
}

public extension NaverMap where MarkerItems == _DefaultMarkerItems {
    init(
        cameraPosition: Binding<NMFCameraPosition>,
        positionMode: Binding<NMFMyPositionMode> = .constant(.disabled),
        lineCoordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    ) {
        self._cameraPosition = cameraPosition
        self._positionMode = positionMode
        self.lineCoordinates = lineCoordinates
        markerItems = []
    }
}

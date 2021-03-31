//
//  ListEditeur.swift
//  festival-du-jeu-front-ios
//
//  Created by user190184 on 27/03/2021.
//

import Foundation

protocol ListZoneDelegate {
    func listZoneModified(zone: Zone, index: Int)
    func newListZone()
    func listZonesAdded(zones: [Zone])
    func listZonesDeleted()
    func ZoneDeleted(at: Int)
}


class ListZone : ObservableObject{
        
    var delegate : ListZoneDelegate?
    
    private(set) var zones = [Zone]()
    
    func add(zone: Zone){
        self.zones.append(zone)
        self.delegate?.listZoneModified(zone: zone, index: self.zones.count-1)
    }
    
    func new(zones: [Zone]){
        self.zones = zones
        self.delegate?.newListZone()
    }
    func add(zones: [Zone]){
        self.zones.append(contentsOf: zones)
        self.delegate?.listZonesAdded(zones: zones)
    }
    func removeAllZones(){
        self.zones.removeAll()
        self.delegate?.listZonesDeleted()
    }
}

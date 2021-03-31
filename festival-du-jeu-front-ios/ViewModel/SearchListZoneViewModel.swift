

import Foundation
import SwiftUI
import Combine

enum SearchListZonesState : CustomStringConvertible{
    case ready
    case loading(String)
    case loaded([Zone])
    case loadingError(Error)
    case newZones([ZoneViewModel])

    var description: String{
        switch self {
        case .ready                               : return "ready"
        case .loading(let s)                      : return "loading: \(s)"
        case .loaded(let zones)                  : return "loaded: \(zones.count) editeurs"
        case .loadingError(let error)             : return "loadingError: Error loading -> \(error)"
        case .newZones(let zones)               : return "newEditeur: reset editeurs with \(zones.count)"

        }
    }
    
}


class SearchListZoneViewModel:  ObservableObject, ListZoneDelegate{
    
    func ZoneDeleted(at: Int) {
        
    }
    
    
    func listZoneModified(zone: Zone, index: Int) {
        
    }
    
    func newListZone() {
        self.zones.removeAll()
        for zone in self.model.zones{
            self.zones.append(ZoneViewModel(zone: zone))
        }
        #if DEBUG
        debugPrint("SearchPlvm: editeursState = .newEditeurs")
        #endif
        self.listZonesState = .newZones(self.zones)
        
    }
    
    func listZonesAdded(zones: [Zone]) {
        
    }
    
    func listZonesDeleted() {
        
    }
    
    
    
    
    /// Playlist model of ViewModel
    private(set) var model: ListZone
    
    /// tracks of TrackViewModel synchronized with tracks of playlist model
    @Published private(set) var zones = [ZoneViewModel]()
    
    @Published var zoneAddingError : Bool = false{ //Si il n'y a pas d'erreurs on passe en état ready
        didSet{
            if !zoneAddingError{
            listZonesState = .ready
            }
        }
    }
    
    /// State of new data loading for playlist
    @Published var listZonesState : SearchListZonesState = .ready{
        didSet{
            #if DEBUG
            debugPrint("SearchPlvm : state.didSet = \(listZonesState)")
            #endif
            switch self.listZonesState { // state has changed
            case let .loaded(data):
                self.model.new(zones: data)
            case .loadingError:
                print("ERROR")
                //TODO : Gestion des erreurs
            default:
                return
            }
        }
    }
    
    /// initialization
    /// - Parameter playlist: playlist model to be the ViewModel
    init(_ listZones: ListZone){
        self.model = listZones
        self.model.delegate = self
    }
    
    /// new list of tracks for the playlist
    /// - Parameter tracks: tracks that will define the playlist
    func new(zones: [Zone]){
        #if DEBUG
        debugPrint("SearchPlvm: model.new(jeux:) with \(zones.count) zones")
        #endif
        self.model.new(zones: zones)
    }
    
    /// add new tracks to the playlist
    /// - Parameter tracks: tracks to be added to the playlist
    func add(zones: [Zone]){
        self.model.add(zones: zones)
    }
    
    /// erase playlist
    func removeAllZones(){
        self.model.removeAllZones()
    }
    
    
}


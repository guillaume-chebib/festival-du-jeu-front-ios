//
//  SearchListViewIntent.swift
//  festival-du-jeu-front-ios
//
//  Created by user190184 on 24/03/2021.
//


import Foundation
import SwiftUI

struct ZoneData: Codable {
    public var id_zone: Int
    public var nom_zone: String
}

class SearchListZoneIntent{
    
    @ObservedObject var listZones : SearchListZoneViewModel
    
    init(listZones: SearchListZoneViewModel){
        self.listZones = listZones
    }
    
    func loaded(zones:[Zone]){
        self.listZones.listZonesState = .ready
    }
    
    
    
    func zonesLoaded(){
        self.listZones.listZonesState = .ready
                
    }
    
    func httpJsonLoaded(result: Result<[Zone],HttpRequestError>){
        switch result {
        case let .success(data):
            #if DEBUG
            debugPrint("SearchIntent: httpJsonLoaded -> success -> .loaded(zones)")
            #endif
            
            listZones.listZonesState = .loaded(data)
        
            
            
        case let .failure(error):
            listZones.listZonesState = .loadingError(error)
        }
    }
    
    func loadListeEditeurs() {
        var adresse = "https://festival-du-jeu-api.herokuapp.com/public/festival/zone"
        self.listZones.listZonesState = .loading(adresse)
        //call API with httJson Loaded
        LoadDataFromAPI.loadDataFromAPI(url: adresse,endofrequest: httpJsonLoaded)

    }

    
}

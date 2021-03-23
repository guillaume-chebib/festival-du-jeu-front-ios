//
//  ZoneViewModel.swift
//  festival-du-jeu-front-ios
//
//  Created by user190184 on 23/03/2021.
//

import Foundation
import SwiftUI


class ZoneViewModel :Identifiable{
    
    @ObservedObject private(set) var model : Zone
    
    var id_zone : Int{
        return model.id_zone
    }
    var id_festival : Int {
        return model.id_festival
    }
    var nom_zone: String{
        return model.nom_zone
    }
    
    init(zone:Zone) {
        self.model=zone
    }

    
}

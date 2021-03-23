//
//  Zone.swift
//  festival-du-jeu-front-ios
//
//  Created by user190184 on 23/03/2021.
//

import Foundation
import SwiftUI

class Zone: Identifiable,ObservableObject, Encodable {
    
    private(set) var id_zone:Int
    private(set) var id_festival:Int
    private(set) var nom_zone:String
    
    init(id_zone: Int,id_festival: Int, nom_zone: String){
        self.id_zone = id_zone
        self.id_festival = id_festival
        self.nom_zone = nom_zone
    }
}

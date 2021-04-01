//
//  JeuViewModel.swift
//
//  Created by Groupe 7 on 23/03/2021.
//

import Foundation
import SwiftUI


class JeuViewModel :Identifiable{
    
    var id = UUID()
    
    @ObservedObject private(set) var model : Jeu
    
    var id_jeu : Int{
        return model.id_jeu
    }
    var titre_jeu : String {
        return model.titre_jeu
    }
    var max_joueur_jeu : Int?{
        return model.max_joueur_jeu
    }
    var min_joueur_jeu : Int{
        return model.min_joueur_jeu
    }
    var age_min_jeu : Int{
        return model.age_min_jeu
    }
    var proto_jeu : Bool {
        return model.proto_jeu
    }
    var url_consignes_jeu : String? {
        return model.url_consignes_jeu
    }
    
    var nom_jeu : String {
        return model.titre_jeu
    }
    
    var nom_societe_jeu : String {
        return model.nom_editeur_jeu
    }
    
    var nom_zone_jeu : String {
        return model.nom_zone_jeu
    }
    
    var duree_jeu : Int {
        return model.duree_jeu
    }

    
    init(_ jeu: Jeu){
        self.model = jeu
    }

    
}

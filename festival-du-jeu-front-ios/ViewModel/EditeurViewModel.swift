//
//  EditeurViewModel.swift
//  festival-du-jeu-front-ios
//
//  Created by user190184 on 27/03/2021.
//


import Foundation
import SwiftUI


class EditeurViewModel :Identifiable{
    
    var id = UUID()

    
    @ObservedObject private(set) var model : Editeur
    
    var id_editeur : Int{
        return model.id_editeur
    }
    
    var nom_editeur: String{
        return model.nom_editeur
    }
    var jeux_editeur : [Jeu]{
        return model.jeux_editeur
    }
    
    init(editeur:Editeur) {
        self.model=editeur
    }

    
}

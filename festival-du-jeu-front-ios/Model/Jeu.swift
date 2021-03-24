//
//  Jeu.swift
//
//  Created by Groupe 7 on 23/03/2021.
//

import Foundation
import SwiftUI
import Combine


// ajouter trackId et albumId
// id devient calculé en fonction si song ou album
// init album et init song

class Jeu : Identifiable, ObservableObject, Encodable, Equatable, CustomStringConvertible{
    static func == (lhs: Jeu, rhs: Jeu) -> Bool {
        return lhs.id == rhs.id
    }
    
    private(set) var id_jeu : Int
    private(set) var titre_jeu: String
    private(set) var min_joueur_jeu: Int
    private(set) var max_joueur_jeu: Int?
    private(set) var age_min_jeu: Int
    private(set) var proto_jeu: Bool
    private(set) var url_consignes_jeu: String?
    
    
    init(id: Int, titre: String, min: Int, max: Int?, age: Int, proto: Bool, url : String?){
        self.id_jeu      = id
        self.titre_jeu    = titre
        self.min_joueur_jeu  = min
        self.max_joueur_jeu   = max
        self.age_min_jeu = age
        self.proto_jeu = proto
        self.url_consignes_jeu = url
    }
    
    
    public var description: String {
            return "id=\(id_jeu), titre=\(titre_jeu)"
        }
}

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

class Jeu : Identifiable, ObservableObject, Encodable, Equatable{
    static func == (lhs: Jeu, rhs: Jeu) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    //static let unknonwCover : UIImage = UIImage(systemName: "questionmark.square.fill")!
    
    /// id du jeu
    private(set) var id_jeu : Int
    /// nom du jeu
    private(set) var titre_jeu: String
    /// artist of the song
    private(set) var min_joueur_jeu: Int
    /// album where this song has been published
    private(set) var max_joueur_jeu: Int?
    /// release date of this track
    private(set) var age_min_jeu: Int
    
    private(set) var proto_jeu: Bool
    
    /// string url of cover album image
    private(set) var url_consignes_jeu: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id_jeu = "id_jeu"
        case titre_jeu = "titre_jeu"
        case min_joueur_jeu = "min_joueur_jeu"
        case max_joueur_jeu = "max_joueur_jeu"
        case age_min_jeu = "age_min_jeu"
        case proto_jeu = "proto_jeu"
        case url_consignes_jeu = "url_consignes_jeu"
    }

    
    /// initialization of a track
    /// - Parameters:
    ///   - id: unique id
    ///   - titre: titre du jeu
    ///   - min: min joueurs
    ///   - max: max joueurs
    ///   - age: age minimum
    ///   - proto: en avant première ?
    ///   - url: url des consignes

    init(id: Int, titre: String, min: Int, max: Int?, age: Int, proto: Bool, url : String?){
        self.id_jeu      = id
        self.titre_jeu    = titre
        self.min_joueur_jeu  = min
        self.max_joueur_jeu   = max
        self.age_min_jeu = age
        self.proto_jeu = proto
        self.url_consignes_jeu = url
    }
}

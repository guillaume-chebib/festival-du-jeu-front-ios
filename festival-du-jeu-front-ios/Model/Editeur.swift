
import Foundation
import SwiftUI
import Combine



//test
class Editeur : Identifiable, ObservableObject, Encodable, Equatable,CustomStringConvertible{
    static func == (lhs: Editeur, rhs: Editeur) -> Bool {
        return lhs.id == rhs.id
    }


//    static let unknonwCover : UIImage = UIImage(systemName: "questionmark.square.fill")!


    private(set) var id_editeur : Int
    private(set) var nom_editeur: String
    private(set) var jeux_editeur : [Jeu]
    //private(set) var est_exposant_societe: String
    //private(set) var est_editeur_societe: String
    //private(set) var est_inactif_societe: String



    /*enum CodingKeys: String, CodingKey {
        case id_societe = "id_societe"
        case nom_societe = "nom_societe"
        case est_exposant_societe = "est_exposant_societe"
        case est_editeur_societe = "est_editeur_societe"
        case est_inactif_societe = "est_inactif_societe"

    }*/

    /*init(id_societe: Int, nom_societe: String, est_exposant_societe: String, est_editeur_societe: String, est_inactif_societe: String) {
        self.id_societe = id_societe
        self.nom_societe = nom_societe
        self.est_exposant_societe = est_exposant_societe
        self.est_editeur_societe = est_editeur_societe
        self.est_inactif_societe = est_inactif_societe
    }*/
    
    init(id_editeur: Int,nom_editeur:String,jeux_editeur:[Jeu]) {
        
        self.id_editeur = id_editeur
        self.nom_editeur = nom_editeur
        self.jeux_editeur = jeux_editeur
    }



    public var description: String {
            return "id=\(id_editeur), titre=\(nom_editeur)"
        }


}

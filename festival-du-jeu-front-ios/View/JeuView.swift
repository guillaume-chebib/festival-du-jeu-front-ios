//
//  JeuView.swift
//  festival-du-jeu-front-ios
//
//  Created by etud on 23/03/2021.
//

import Foundation
import SwiftUI


struct JeuView: View {
    
    let jeu : Jeu



    init(jeu: Jeu){
        self.jeu  = jeu
    }
    
    

    
    var body: some View {
        
        Text(jeu.titre_jeu).font(.title)
            .padding(.horizontal,25)
        Text("Age minimum: " + String(jeu.age_min_jeu))
        Text("Nombre de joueurs minimum: " + String(jeu.min_joueur_jeu))
        Text("Durée: " + String(jeu.duree_jeu ) + " minutes")
        Text("Societe: " + String(jeu.nom_editeur_jeu))
        Text("Zone: " + String(jeu.nom_zone_jeu))
        Spacer()
        	
    }
    
    
    
}



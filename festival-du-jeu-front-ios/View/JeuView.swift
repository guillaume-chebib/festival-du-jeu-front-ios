//
//  JeuView.swift
//  festival-du-jeu-front-ios
//
//  Created by etud on 23/03/2021.
//

import Foundation
//
//  TrackDetail.swift
//  Playlist
//
//  Created by Christophe Fiorio on 21/02/2021.
//

import SwiftUI


struct JeuView: View {
    
    let jeu : JeuViewModel



    init(jeu: JeuViewModel){
        self.jeu  = jeu
    }
    
    

    
    var body: some View {
        
            Text(jeu.titre_jeu)
            Spacer()
        
    }
    
    
    
}



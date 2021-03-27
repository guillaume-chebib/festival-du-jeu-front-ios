//
//  SearchListViewIntent.swift
//  festival-du-jeu-front-ios
//
//  Created by user190184 on 24/03/2021.
//


import Foundation
import SwiftUI

struct EditeurData: Codable {
    public var id_societe: Int
    public var nom_societe: String
}

class SearchListEditeurIntent{
    
    @ObservedObject var listEditeurs : SearchListEditeurViewModel
    
    init(listEditeurs: SearchListEditeurViewModel){
        self.listEditeurs = listEditeurs
    }
    
    func loaded(editeurs:[Editeur]){
        self.listEditeurs.listEditeursState = .ready
    }
    
    
    
    func editeursLoaded(){
        self.listEditeurs.listEditeursState = .ready
                
    }
    
    func httpJsonLoaded(result: Result<[Editeur],HttpRequestError>){
        switch result {
        case let .success(data):
            #if DEBUG
            debugPrint("SearchIntent: httpJsonLoaded -> success -> .loaded(editeurs)")
            #endif
            
            listEditeurs.listEditeursState = .loaded(data)
        
            
            
        case let .failure(error):
            listEditeurs.listEditeursState = .loadingError(error)
        }
    }
    
    func loadListeEditeurs() {
        var adresse = "https://festival-du-jeu-api.herokuapp.com/public/festival/editeur"
        self.listEditeurs.listEditeursState = .loading(adresse)
        //call API with httJson Loaded
        LoadDataFromAPI.loadEditeursFromAPI(url: adresse,endofrequest: httpJsonLoaded)

    }

    
}

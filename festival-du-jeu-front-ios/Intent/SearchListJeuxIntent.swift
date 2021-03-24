//
//  SearchListViewIntent.swift
//  festival-du-jeu-front-ios
//
//  Created by user190184 on 24/03/2021.
//


import Foundation
import SwiftUI

struct JeuData: Codable {
    public var id_jeu: Int
    public var titre_jeu: String
    public var min_joueur_jeu: Int
    public var max_joueur_jeu: Int?
    public var age_min_jeu: Int
    public var proto_jeu: Bool
    public var url_consignes_jeu : String?
}

class SearchListJeuxIntent{
    
    @ObservedObject var listJeux : SearchListJeuxViewModel
    
    init(listJeux: SearchListJeuxViewModel){
        self.listJeux = listJeux
    }
    
    func loaded(jeux:[Jeu]){
        self.listJeux.listJeuxState = .ready
    }
    
    
    
    func jeuLoaded(){
        self.listJeux.listJeuxState = .ready
                
    }
    
    func httpJsonLoaded(result: Result<[Jeu],HttpRequestError>){
        switch result {
        case let .success(data):
            #if DEBUG
            debugPrint("SearchIntent: httpJsonLoaded -> success -> .loaded(tracks)")
            #endif
            
            listJeux.listJeuxState = .loaded(data)
        
            for jeu in data{
                print(data)
            }
            
        case let .failure(error):
            listJeux.listJeuxState = .loadingError(error)
        }
    }
    
    func loadListeJeux() {
        var adresse = "https://festival-du-jeu-api.herokuapp.com/public/festival/20/jeu"
        self.listJeux.listJeuxState = .loading(adresse)
        //call API with httJson Loaded
        LoadDataFromAPI.loadTracksFromAPI(url: adresse,endofrequest: httpJsonLoaded)
                
    }
    
}
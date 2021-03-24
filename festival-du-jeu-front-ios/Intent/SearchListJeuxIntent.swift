//
//  SearchListViewIntent.swift
//  festival-du-jeu-front-ios
//
//  Created by user190184 on 24/03/2021.
//


import Foundation
import SwiftUI



class SearchListJeuxIntent{
    
    @ObservedObject var listJeux : SearchListJeuxViewModel
    
    init(listJeux: SearchListJeuxViewModel){
        self.listJeux = listJeux
    }
    
    func loaded(jeux:[Jeu]){
        self.listJeux.listJeuxState = .ready
    }
    
    func httpJsonLoaded(result: Result<[Jeu],HttpRequestError>){
        switch result {
        case let .success(data):
            listJeux.listJeuxState = .loaded(data)
        case let .failure(error):
            listJeux.listJeuxState = .loadingError(error)
        }
        
    }
    
    func jeuLoaded(){
        self.listJeux.listJeuxState = .ready
                
    }

    func loadListeJeux() {
        var adresse = ""
        //self.listJeux.listJeuxState = .loading(url)
        //call API with httJson Loaded
        
    }
    
}

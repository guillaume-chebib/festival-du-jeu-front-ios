//
//  SearchListViewIntent.swift
//  festival-du-jeu-front-ios
//
//  Created by user190184 on 24/03/2021.
//


import Foundation
import SwiftUI



class SearchListeJeuxIntent{
    
    //@ObservedObject var listeJeux : SearchListeJeuxViewModel
    
    /*init(listeJeux: SearchListeJeuxViewModel){
        self.listeJeux = listeJeux
    }*/
    
    func loaded(jeux:[Jeu]){
        self.listeJeux.State = .ready
    }
    
    func httpJsonLoaded(result: Result<[Jeu],HttpRequestError>){
        switch result {
        case let .success(data):
                listeJeux.State = .loaded(data)
        case let .failure(error):
           listeJeux.State = .loadingError(error)
        }
        
    }
    
    func jeuLoaded(){
        self.listeJeux.State = .ready
                
    }

    func loadListeJeux() {
        var adresse - ""
        self.listeJeux.State = .loading(url)
        //call API with httJson Loaded
        
    }
    
}

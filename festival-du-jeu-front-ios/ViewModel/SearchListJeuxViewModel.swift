//
//  PlaylistViewModel.swift
//  Playlist
//
//  Created by user191010 on 18/02/2021.
//

import Foundation
import SwiftUI
import Combine

enum SearchListJeuxState : CustomStringConvertible{
    case ready
    case loading(String)
    case loaded([Jeu])
    case loadingError(Error)
    case newJeux([JeuViewModel])

    var description: String{
        switch self {
        case .ready                               : return "ready"
        case .loading(let s)                      : return "loading: \(s)"
        case .loaded(let jeu)                  : return "loaded: \(jeu.count) jeux"
        case .loadingError(let error)             : return "loadingError: Error loading -> \(error)"
        case .newJeux(let jeux)               : return "newTracks: reset playlist with \(jeux.count) tracks"

        }
    }
    
}


class SearchListJeuxViewModel: ObservableObject, ListJeuxDelegate{
    
    func listJeuxModified(jeu: Jeu, index: Int) {
        
    }
    
    func newListJeux() {
        self.jeux.removeAll()
        for jeu in self.model.jeux{
            self.jeux.append(JeuViewModel(jeu))
        }
        #if DEBUG
        debugPrint("SearchPlvm: playListState = .newTracks")
        #endif
        self.listJeuxState = .newJeux(self.jeux)
        
    }
    
    func listJeuxAdded(jeux: [Jeu]) {
        
    }
    
    func listJeuxDeleted() {
        
    }
    
    func jeuDeleted(at: Int) {
        
    }
    
    
    /// Playlist model of ViewModel
    private(set) var model: ListJeux
    
    /// tracks of TrackViewModel synchronized with tracks of playlist model
    @Published private(set) var jeux = [JeuViewModel]()
    
    @Published var trackAddingError : Bool = false{ //Si il n'y a pas d'erreurs on passe en état ready
        didSet{
            if !trackAddingError{
            listJeuxState = .ready
            }
        }
    }
    
    /// State of new data loading for playlist
    @Published var listJeuxState : SearchListJeuxState = .ready{
        didSet{
            #if DEBUG
            debugPrint("SearchPlvm : state.didSet = \(listJeuxState)")
            #endif
            switch self.listJeuxState { // state has changed
            case let .loaded(data):
                self.model.new(jeux: data)
            case .loadingError:
                print("ERROR")
                //TODO : Gestion des erreurs
            default:
                return
            }
        }
    }
    
    /// initialization
    /// - Parameter playlist: playlist model to be the ViewModel
    init(_ listJeux: ListJeux){
        self.model = listJeux
        self.model.delegate = self
    }
    
    /// new list of tracks for the playlist
    /// - Parameter tracks: tracks that will define the playlist
    func new(jeux: [Jeu]){
        #if DEBUG
        debugPrint("SearchPlvm: model.new(jeux:) with \(jeux.count) jeux")
        #endif
        self.model.new(jeux: jeux)
    }
    
    /// add new tracks to the playlist
    /// - Parameter tracks: tracks to be added to the playlist
    func add(jeux: [Jeu]){
        self.model.add(jeux: jeux)
    }
    
    /// erase playlist
    func removeAllTracks(){
        self.model.removeAllJeux()
    }
    
}


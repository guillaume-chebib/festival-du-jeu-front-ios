//
//  PlaylistViewModel.swift
//  Playlist
//
//  Created by Christophe Fiorio on 18/02/2021.
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
        case .newJeux(let jeux)               : return "newJeux: reset list with \(jeux.count) jeux"
        }
    }
    
}


class SearchListJeuxViewModel: ListJeuxDelegate, ObservableObject{
    
    /// Playlist model of ViewModel
    private(set) var model: ListJeux
    
    /// tracks of TrackViewModel synchronized with tracks of playlist model
    @Published private(set) var jeux = [JeuViewModel]()
    
    @Published var trackAddingError : Bool = false{
        didSet{
            if !trackAddingError{
            listJeuxState = .ready
            }
        }
    }
    /// disclosure form is opened or closed according to a bool
    /// idealy, we should set this bool in SearchListView to false when state becomes .loaded or .loadingError
    /// but this bool has to be a @State var or a @Published var and change of state will be observed in view when the body has to be recomputed,
    /// i.e. when view is redisplayed, and  change in @State var or @Published var are not taken into account during a view drawing
    /// so the bool will not change and disclosure will not be closed
    /// It is why, the viewmodel handles this bool and tell the view when close the disclosure according to state change
    @Published var formViewOpen = false

    /// State of new data loading for playlist
    @Published var listJeuxState : SearchListJeuxState = .ready{
        didSet{
            #if DEBUG
            debugPrint("SearchPlvm : state.didSet = \(listJeuxState)")
            #endif
            switch self.listJeuxState { // state has changed
            case let .loaded(data):    // new data has been loaded, to change all tracks of playlist
                self.formViewOpen = false // close searchFormView, new tracks have been found
                #if DEBUG
                debugPrint("SearchPlvm: jeu loaded => formViewOpen=\(formViewOpen) -> model.new(jeux:)")
                #endif
                self.model.new(jeux: data)
            case .loadingError:
                self.formViewOpen = true // reopen or keep open searchFormView as there is an error on loading new tracks
            default:                   // nothing to do for ViewModel, perhaps for the view
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
    
    // ---------------------------------------------------------------------------------------------------------
    // MARK: -
    // MARK: Playlist delegate
    
    /// called when playlist model has been modified
    ///
    /// if index exists, then this track has replaced the track already there, else track has been append to the list.
    /// - Parameters:
    ///   - track: track that is put into the list
    ///   - index: index where to set the track
    /// called when playlist model has been deleted
    func listJeuxDeleted(){
        self.jeux.removeAll()
    }
    /// called when playlist model has changed all its list of tracks
    func newListJeux() {
        #if DEBUG
        debugPrint("SearchPlvm: newListJeux()")
        #endif
        self.jeux.removeAll()
        for jeu in self.model.jeux {
            self.jeux.append(JeuViewModel(jeu))
        }
        #if DEBUG
        debugPrint("SearchPlvm: playListState = .newTracks")
        #endif
        self.listJeuxState = .newJeux(self.jeux)
    }
    /// call when a set of tracks has been append to the playlist
    /// - Parameter tracks: tracks to be added
    func listJeuxAdded(jeux: [Jeu]) {
        for jeu in jeux{
            self.jeux.append(JeuViewModel(jeu))
        }
        self.listJeuxState = .newJeux(self.jeux)
    }
    
    func listJeuxModified(jeu: Jeu, index: Int) {
        return // SearchPlaylistViewModel manages loading an entire set of tracks, not individual change of track of the list
    }
    func jeuDeleted(at index: Int) {
        return // SearchPlaylistViewModel manages loading an entire set of tracks, not individual change of track of the list
    }

    func jeuxMoved(from source: IndexSet, to destination: Int) {
        return // SearchPlaylistViewModel manages loading an entire set of tracks, not individual change of track of the list
    }
    
}



import Foundation
import SwiftUI
import Combine

enum SearchListEditeursState : CustomStringConvertible{
    case ready
    case loading(String)
    case loaded([Editeur])
    case loadingError(Error)
    case newEditeurs([EditeurViewModel])

    var description: String{
        switch self {
        case .ready                               : return "ready"
        case .loading(let s)                      : return "loading: \(s)"
        case .loaded(let editeurs)                  : return "loaded: \(editeurs.count) editeurs"
        case .loadingError(let error)             : return "loadingError: Error loading -> \(error)"
        case .newEditeurs(let editeurs)               : return "newEditeur: reset editeurs with \(editeurs.count)"

        }
    }
    
}


class SearchListEditeurViewModel:  ObservableObject, ListEditeurDelegate{
    
    func EditeurDeleted(at: Int) {
        
    }
    
    
    func listEditeurModified(editeur: Editeur, index: Int) {
        
    }
    
    func newListEditeur() {
        self.editeurs.removeAll()
        for editeur in self.model.editeurs{
            self.editeurs.append(EditeurViewModel(editeur: editeur))
        }
        #if DEBUG
        debugPrint("SearchPlvm: editeursState = .newEditeurs")
        #endif
        self.listEditeursState = .newEditeurs(self.editeurs)
        
    }
    
    func listEditeursAdded(editeurs: [Editeur]) {
        
    }
    
    func listEditeursDeleted() {
        
    }
    
    
    
    
    /// Playlist model of ViewModel
    private(set) var model: ListEditeur
    
    /// tracks of TrackViewModel synchronized with tracks of playlist model
    @Published private(set) var editeurs = [EditeurViewModel]()
    
    @Published var editeurAddingError : Bool = false{ //Si il n'y a pas d'erreurs on passe en état ready
        didSet{
            if !editeurAddingError{
            listEditeursState = .ready
            }
        }
    }
    
    /// State of new data loading for playlist
    @Published var listEditeursState : SearchListEditeursState = .ready{
        didSet{
            #if DEBUG
            debugPrint("SearchPlvm : state.didSet = \(listEditeursState)")
            #endif
            switch self.listEditeursState { // state has changed
            case let .loaded(data):
                self.model.new(editeurs: data)
            case .loadingError:
                print("ERROR")
                //TODO : Gestion des erreurs
            default:
                return
            }
        }
    }
    
    /// initialization/Users/etud/Documents/festival-du-jeu-front-ios/festival-du-jeu-front-ios/Model/ListEditeur.swift
    /// - Parameter playlist: playlist model to be the ViewModel
    init(_ listEditeurs: ListEditeur){
        self.model = listEditeurs
        self.model.delegate = self
    }
    
    /// new list of tracks for the playlist
    /// - Parameter tracks: tracks that will define the playlist
    func new(editeurs: [Editeur]){
        #if DEBUG
        debugPrint("SearchPlvm: model.new(jeux:) with \(editeurs.count) editeurs")
        #endif
        self.model.new(editeurs: editeurs)
    }
    
    /// add new tracks to the playlist
    /// - Parameter tracks: tracks to be added to the playlist
    func add(editeurs: [Editeur]){
        self.model.add(editeurs: editeurs)
    }
    
    /// erase playlist
    func removeAllEditeurs(){
        self.model.removeAllEditeurs()
    }
    
    
}


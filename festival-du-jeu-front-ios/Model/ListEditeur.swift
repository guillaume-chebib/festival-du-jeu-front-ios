//
//  ListEditeur.swift
//  festival-du-jeu-front-ios
//
//  Created by user190184 on 27/03/2021.
//

import Foundation

protocol ListEditeurDelegate {
    func listEditeurModified(editeur: Editeur, index: Int)
    func newListEditeur()
    func listEditeursAdded(editeurs: [Editeur])
    func listEditeursDeleted()
    func EditeurDeleted(at: Int)
}


class ListEditeur : ObservableObject{
        
    var delegate : ListEditeurDelegate?
    
    private(set) var editeurs = [Editeur]()
    
    func add(editeur: Editeur){
        self.editeurs.append(editeur)
        self.delegate?.listEditeurModified(editeur: editeur, index: self.editeurs.count-1)
    }
    
    func new(editeurs: [Editeur]){
        self.editeurs = editeurs
        self.delegate?.newListEditeur()
    }
    func add(editeurs: [Editeur]){
        self.editeurs.append(contentsOf: editeurs)
        self.delegate?.listEditeursAdded(editeurs: editeurs)
    }
    func removeAllEditeurs(){
        self.editeurs.removeAll()
        self.delegate?.listEditeursDeleted()
    }
}

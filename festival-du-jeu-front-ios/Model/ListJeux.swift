import Foundation

protocol ListJeuxDelegate {
    func listJeuxModified(jeu: Jeu, index: Int)
    func newListJeux()
    func listJeuxAdded(jeux: [Jeu])
    func listJeuxDeleted()
    func jeuDeleted(at: Int)
}


class ListJeux : ObservableObject{
        
    var delegate : ListJeuxDelegate?
    
    private(set) var jeux = [Jeu]()
    
    func add(jeu: Jeu){
        self.jeux.append(jeu)
        self.delegate?.listJeuxModified(jeu: jeu, index: self.jeux.count-1)
    }
    func new(jeux: [Jeu]){
        self.jeux = jeux
        self.delegate?.newListJeux()
    }
    func add(jeux: [Jeu]){
        self.jeux.append(contentsOf: jeux)
        self.delegate?.listJeuxAdded(jeux: jeux)
    }
    func removeAllJeux(){
        self.jeux.removeAll()
        self.delegate?.listJeuxDeleted()
    }
}

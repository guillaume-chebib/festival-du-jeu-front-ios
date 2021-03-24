//
//  LoadDataFromApi.swift
//  festival-du-jeu-front-ios
//
//  Created by user190184 on 24/03/2021.
//


import Foundation
import SwiftUI

struct FestivalData : Codable {
    var id_festival:Int
    var nom_festival:String
    var annee_festival:Int
    var est_courant_festival:Bool
    
}
struct JeuData: Codable {
    var id_jeu: Int
    var titre_jeu: String
    var min_joueur_jeu: Int
    var max_joueur_jeu: Int?
    var age_min_jeu: Int
    var prototype_jeu: Bool
    var id_type_jeu_jeu :Int
    var id_editeur_jeu: Int
    var url_jeu : String?
}

struct JeuxData: Codable {
    var resultCount: Int
    var results: [JeuData]
}
enum HttpRequestError : Error, CustomStringConvertible{
    case fileNotFound(String)
    case badURL(String)
    case failingURL(URLError)
    case requestFailed
    case outputFailed
    case JsonDecodingFailed
    case JsonEncodingFailed
    case initDataFailed
    case unknown
    
    var description : String {
        switch self {
        case .badURL(let url): return "Bad URL : \(url)"
        case .failingURL(let error): return "URL error : \(error.failureURLString ?? "")\n \(error.localizedDescription)"
        case .requestFailed: return "Request Failed"
        case .outputFailed: return "Output data Failed"
        case .JsonDecodingFailed: return "JSON decoding failed"
        case .JsonEncodingFailed: return "JSON encoding failed"
        case .initDataFailed: return "Bad data format: initialization of data failed"
        case .unknown: return "unknown error"
        case .fileNotFound(let filename): return "File \(filename) not found"
        }
    }
}


struct LoadDataFromAPI {
    
    @State var searchResult : [Jeu] = []
        
        init(){
            self.searchResult = []
        }
    
    func search(text : String){
            let surl = "https://festival-du-jeu-api.herokuapp.com/festival/20/jeu"
            print(surl)
            guard let url = URL(string: surl) else { return }
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) {
                        data, // données retournées par la requête
                        response, // description des données - combien de données, le type, etc...
                        error // code d'erreur ?
                        in // closure -- lambda expression -- exécuté au retour de la requête

                 // à partir de là vous pouvez procéder comme avec la lecture dans un fichier, data étant les données que vous auriez récupérées depuis le fichier
                
                guard let data = try? Data(contentsOf: url) else {
                    fatalError("Failed to load file in bundle")
                }
        
                let decoder = JSONDecoder()
        
                guard let loaded = try? decoder.decode(JeuxData.self,from: data) else{
                    fatalError("failed to decode file from bundle")
                }
                
                 // on vérifie qu'on a bien des données
                 // on crée un décodeur
                 // on décode

                 // maintenant il faut mettre à jour les données du modèle
                 // mais ça doit se faire dans le thread principal si on veut que ce soit pris en compte par la vue et l'intent
                 DispatchQueue.main.async { // met dans la file d'attente du thread principal l'action qui suit
                    for jeu in loaded.results {
                        self.searchResult.append(Jeu(id: jeu.id_jeu, titre: jeu.titre_jeu, min: jeu.min_joueur_jeu, max: jeu.max_joueur_jeu, age: jeu.age_min_jeu, proto: jeu.prototype_jeu, url : jeu.url_jeu))
                    }
                                     
                 }
                 return

            }.resume()
            
        }
}

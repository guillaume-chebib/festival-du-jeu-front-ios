//
//  LoadDataFromApi.swift
//  festival-du-jeu-front-ios
//
//  Created by user190184 on 24/03/2021.
//


import Foundation
import SwiftUI

struct FestivalData : Codable {
    public var id_festival:Int
    public var nom_festival:String
    public var annee_festival:Int
    public var est_courant_festival:Bool
    
}


struct JeuxData: Codable {
    public var jeux: [JeuData]
}

struct EditeursData: Codable {
    public var societe: EditeurData
    public var jeux: [JeuData]
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


class LoadDataFromAPI {
    
    var searchResult : [Jeu] = []
    var searchResultEditeurs : [Editeur] = []
        
        init(){
            self.searchResult = []
            self.searchResultEditeurs = []
        }
    
    
    static func jeuData2Jeu(data: [JeuData]) -> [Jeu]?{
        var jeux = [Jeu]()
        for tdata in data{
            
            
            let jeu = Jeu(id: tdata.id_jeu, titre: tdata.titre_jeu, min: tdata.min_joueur_jeu, max: tdata.max_joueur_jeu, age: tdata.age_min_jeu, proto: tdata.proto_jeu, url: tdata.url_consignes_jeu)
            jeux.append(jeu)
        }
        return jeux
    }
    
    static func editeursData2Editeurs(data: [EditeursData]) -> [Editeur]?{
        var editeurs = [Editeur]()
        for tdata in data{
            let editeur = Editeur(id_editeur: tdata.societe.id_societe, nom_editeur: tdata.societe.nom_societe, jeux_editeur: jeuData2Jeu(data: tdata.jeux) ?? [Jeu(id: 0, titre: "1", min: 0, max: 0, age: 0, proto: false, url: "a")])
            editeurs.append(editeur)
        }
        return editeurs
    }
    
    static func loadJeuxFromAPI(url surl: String, endofrequest: @escaping (Result<[Jeu],HttpRequestError>) -> Void){
        guard let url = URL(string: surl) else {
            endofrequest(.failure(.badURL(surl)))
            return
        }
        self.loadJeuxFromAPI(url: url, endofrequest: endofrequest)
    }
    
    static func loadEditeursFromAPI(url surl: String, endofrequest: @escaping (Result<[Editeur],HttpRequestError>) -> Void){
        guard let url = URL(string: surl) else {
            endofrequest(.failure(.badURL(surl)))
            return
        }
        self.loadEditeursFromAPI(url: url, endofrequest: endofrequest)
    }
    
    
    static func loadJeuxFromAPI(url: URL, endofrequest: @escaping (Result<[Jeu],HttpRequestError>) -> Void){
        self.search(url: url, endofrequest: endofrequest)
    }
    
    static func loadEditeursFromAPI(url: URL, endofrequest: @escaping (Result<[Editeur],HttpRequestError>) -> Void){
        self.searchEditeurs(url: url, endofrequest: endofrequest)
    }
    static func search(url: URL, endofrequest: @escaping (Result<[Jeu],HttpRequestError>) -> Void){
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decodedData : Decodable?
                
                
                    decodedData = try? JSONDecoder().decode([JeuData].self, from: data)
                
                guard let decodedResponse = decodedData else {
                    DispatchQueue.main.async { endofrequest(.failure(.JsonDecodingFailed)) }
                    return
                }
                var jeuxData : [JeuData]
                
                    jeuxData = (decodedResponse as! [JeuData])
                
                guard let jeux = self.jeuData2Jeu(data: jeuxData) else{
                    DispatchQueue.main.async { endofrequest(.failure(.JsonDecodingFailed)) }
                    return
                }
                DispatchQueue.main.async {
                    endofrequest(.success(jeux))
                }
            }
            else{
                DispatchQueue.main.async {
                    if let error = error {
                        guard let error = error as? URLError else {
                            endofrequest(.failure(.unknown))
                            return
                        }
                        endofrequest(.failure(.failingURL(error)))
                    }
                    else{
                        guard let response = response as? HTTPURLResponse else{
                            endofrequest(.failure(.unknown))
                            return
                        }
                        guard response.statusCode == 200 else {
                            endofrequest(.failure(.requestFailed))
                            return
                        }
                        endofrequest(.failure(.unknown))
                    }
                }
            }
        }.resume()
    }
    
    static func searchEditeurs(url: URL, endofrequest: @escaping (Result<[Editeur],HttpRequestError>) -> Void){
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decodedData : Decodable?
                
                
                    decodedData = try? JSONDecoder().decode([EditeursData].self, from: data)
                
                guard let decodedResponse = decodedData else {
                    DispatchQueue.main.async { endofrequest(.failure(.JsonDecodingFailed)) }
                    return
                }
                
                var editeursData : [EditeursData]
                
                editeursData = (decodedResponse as! [EditeursData])
                
                
                
                guard let editeurs = self.editeursData2Editeurs(data: editeursData) else{
                    DispatchQueue.main.async { endofrequest(.failure(.JsonDecodingFailed)) }
                    return
                }
                DispatchQueue.main.async {
                    endofrequest(.success(editeurs))
                }
            }
            else{
                DispatchQueue.main.async {
                    if let error = error {
                        guard let error = error as? URLError else {
                            endofrequest(.failure(.unknown))
                            return
                        }
                        endofrequest(.failure(.failingURL(error)))
                    }
                    else{
                        guard let response = response as? HTTPURLResponse else{
                            endofrequest(.failure(.unknown))
                            return
                        }
                        guard response.statusCode == 200 else {
                            endofrequest(.failure(.requestFailed))
                            return
                        }
                        endofrequest(.failure(.unknown))
                    }
                }
            }
        }.resume()
    }
}

//
//  LoadDataFromApi.swift
//  festival-du-jeu-front-ios
//
//  Created by user190184 on 24/03/2021.
//

import Foundation

struct FestivalData : Codable {
    var id_festival:Int
    var nom_festival:String
    var annee_festival:Int
    var est_courant_festival:Bool
    
}
struct JeuData: Codable {
    var id_jeu: Int
    var titre_jeu: String
    var min_joueur_jeu: String
    var max_joueur_jeu: String?
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
    
    static func loadJeuxFromAPI(url surl: String, endofrequest: @escaping (Result<[Jeu],HttpRequestError>) -> Void){
        guard let url = URL(string: surl) else {
            endofrequest(.failure(.badURL(surl)))
            return
        }
        self.loadJeuxFromAPI(url: url, endofrequest: endofrequest)
    }
    static func loadJeuxFromAPI(url: URL, endofrequest: @escaping (Result<[Jeu],HttpRequestError>) -> Void){
        self.loadJeuxFromJsonData(url: url, endofrequest: endofrequest, ItuneApiRequest: true)
    }

    private static func loadJeuxFromJsonData(url: URL, endofrequest: @escaping (Result<[Jeu],HttpRequestError>) -> Void, ItuneApiRequest: Bool = true){
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decodedData : Decodable?
                if ItuneApiRequest{
                    decodedData = try? JSONDecoder().decode(JeuData.self, from: data)
                }
                else{
                    decodedData = try? JSONDecoder().decode([JeuData].self, from: data)
                }
                guard let decodedResponse = decodedData else {
                    DispatchQueue.main.async { endofrequest(.failure(.JsonDecodingFailed)) }
                    return
                }
                var tracksData : [JeuData]
                if ItuneApiRequest{
                    tracksData = (decodedResponse as! JeuData).results
                }
                else{
                    tracksData = (decodedResponse as! [TrackData])
                }
                guard let tracks = self.trackData2Track(data: tracksData) else{
                    DispatchQueue.main.async { endofrequest(.failure(.JsonDecodingFailed)) }
                    return
                }
                DispatchQueue.main.async {
                    endofrequest(.success(tracks))
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
    }}

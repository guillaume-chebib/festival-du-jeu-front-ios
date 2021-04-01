

import SwiftUI
import Combine




struct HomePageView: View {
    
    @ObservedObject var searchListJeux : SearchListJeuxViewModel
    var intent : SearchListJeuxIntent
    init(searchListJeux: SearchListJeuxViewModel){
        self.searchListJeux = searchListJeux
        self.intent = SearchListJeuxIntent(listJeux: searchListJeux)
        print("nouvelle vue")
        if case .ready = self.searchListJeux.listJeuxState {
        self.intent.loadListeJeux()
        }
        if case .newJeux = self.searchListJeux.listJeuxState{
            /*let _  = self.searchListJeux.$listJeuxState.sink(receiveValue: stateChanged)*/
        }
    }
    
    func stateChanged(state: SearchListJeuxState){
        
        switch state {
        case .newJeux:
            self.intent.jeuxLoaded()
        default:
            break
        }
    }
    

    private var searchState : SearchListJeuxState{
        return self.searchListJeux.listJeuxState
    }
    
    var jeux : [JeuViewModel] {
        return self.searchListJeux.jeux
    }
    
    @State private var text: String = ""

    @State private var isEditing = false
    
    func filterSearch(jeu: JeuViewModel) -> Bool {
        
        var res: Bool = true
        
        if (!text.isEmpty) {
            res = jeu.titre_jeu.lowercased().contains(text.lowercased())
        }
                
        return res
    }

    
    var body: some View {
//        stateChanged(state: searchPlaylist.playListState)
        return NavigationView{
            VStack{
                Spacer()
                HStack {
                    Button(action: {
                            self.intent.loadListeJeux()}){
                        Label("", systemImage: "arrow.clockwise")
                            .padding(15)
                    }
                    TextField("Rechercher ...", text: $text)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            self.isEditing = true
                        }

                    if isEditing {
                        Button(action: {
                            self.isEditing = false
                            self.text = ""

                        }) {
                            Text("Annuler")
                        }
                        .padding(.trailing, 10)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                    }
                }
                Spacer()
                ZStack{
                    List{
                        ForEach(self.searchListJeux.jeux.filter(filterSearch)){ jeu in
                            NavigationLink(destination: JeuView(jeu:jeu.model)){
                                ListRow(jeu: jeu.model)
                            }
                        }
                    }
                    if jeux.count == 0{
                        VStack{
                            Spacer()
                            Text("Aucun jeu disponible")
                            Spacer()
                        }
                    }
                    ErrorViewJeux(state: searchState)
                }
            }
            .navigationTitle("Liste des jeux")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SearchListView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(searchListJeux: SearchListJeuxViewModel(ListJeux()))
        
    }
}

struct ListRow : View{
    let jeu : Jeu
    var body: some View{
        HStack{
            VStack(alignment: .leading){
                Text("\(jeu.titre_jeu)")
                    .font(.headline)
            }
        }
    }
}

struct ErrorViewJeux : View{
    let state : SearchListJeuxState
    var body: some View{
        VStack{
            Spacer()
            switch state{
            case .loading, .loaded:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(3)
            case .loadingError(let error):
                ErrorMessage(error: error)
            default:
                EmptyView()
            }
            if case let .loaded(data) = state{
                Text("\(data.count) jeux trouvées!")
            }
            Spacer()
        }
    }
}




struct ErrorMessage : View{
    let error :  Error
    var body: some View{
        VStack{
            Text("Erreurs de la requête")
                .foregroundColor(.red)
                .font(.title)
            if let error = error  as? HttpRequestError {
                Text("\(error.description)")
                    .italic()
                    .foregroundColor(.gray)
            }
            else{
                Text("Unknown error")
                    .foregroundColor(.red)
                    .font(.title)
            }
        }
    }
}

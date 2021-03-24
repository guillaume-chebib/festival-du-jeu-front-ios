

import SwiftUI
import Combine




struct HomePageView: View {
    
    @ObservedObject var searchListJeux : SearchListJeuxViewModel
    var intent : SearchListJeuxIntent
    init(searchListJeux: SearchListJeuxViewModel){
        self.searchListJeux = searchListJeux
        self.intent = SearchListJeuxIntent(listJeux: searchListJeux)
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

    
    var body: some View {
//        stateChanged(state: searchPlaylist.playListState)
        return NavigationView{
            VStack{
                Text("Bienvenue sur l'app du fetival du jeu")
                Spacer()
                HStack {
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
                        ForEach(self.searchListJeux.jeux){ jeu in
                            ListRow(jeu: jeu)
                        }
                    }
                    if jeux.count == 0{
                        VStack{
                            Spacer()
                            Text("Aucun jeu disponible")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Accueil")
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
    let jeu : JeuViewModel
    var body: some View{
        HStack{
            VStack(alignment: .leading){
                Text("\(jeu.titre_jeu) \(jeu.id_jeu)")
                    .font(.headline)
            }
        }
    }
}



import SwiftUI
import Combine




struct HomePageView: View {
    
    /*
     * If searchPlaylist is initialized here, we must ensure that intent initialized here stays the same with the initial playlist
     * Else intent could manage another playlist if struct is reinit
     * The way to do that is a bit complicated but possible (see solution in comment below)
     * So the best is to pass searchPlaylist in parameter so, even if struct is reinit and intent recreated, it will manage the good searchplaylist
     *
    // MUST be a StateObject to stay the same and not being reallocated if struct is reinit
    @StateObject var searchPlaylist : SearchPlaylistViewModel
    // MUST be a StateObject to stay the same and not being reallocated if struct is reinit
    @StateObject var intent : SearchListViewIntent

    
    /// initialize view: create the search playlist and the intent of the view
    init(){
        let playlist    = SearchPlaylistViewModel(Playlist()) // create a searchList
        _searchPlaylist = StateObject(wrappedValue: playlist) // if searchPlaylist has already been allocated, this statement has no effect
        _intent         = StateObject(wrappedValue: SearchListViewIntent(playlist: playlist)) // same thing for intent
        // note : if intent whas not a StateObject, when struct is reallocated, a new intent is created with local playlist created here, and so
        // intent will no more manage the initial playlist!
    }
     */
    
    @ObservedObject var searchListJeux : SearchListJeuxViewModel
    var intent : SearchListJeuxIntent
    init(searchListJeux: SearchListJeuxViewModel){
        self.searchListJeux = searchListJeux
        self.intent = SearchListJeuxIntent(listJeux: searchListJeux)
        let _  = self.searchListJeux.$listJeuxState.sink(receiveValue: stateChanged)
        //search(text: "a")
        self.intent.loadListeJeux()
    }
    
    

    private var searchState : SearchListJeuxState{
        return self.searchListJeux.listJeuxState
    }
    
    @State private var showModal      = false
    @State var detailPresented : Bool = false
    @State var revealSearchForm: Bool = false
    @State var textSearch             = ""
    
    /// Use to fake DetailView when displayed in DisclosureGroupe as DetailView need such bool when used in Modal view
    @State var dumbPresented : Bool = true
    
    
    var jeux : [JeuViewModel] {
        return self.searchListJeux.jeux
    }
    
//    private func filterSearch(jeu: JeuViewModel) -> Bool{
//        var ret = true
//        if !textSearch.isEmpty {
//            ret = false
//            if let name = jeu.titre_jeu{
//                ret = ret || name.contains(textSearch)
//            }
//            ret = ret || jeu.album.contains(textSearch)
//            ret = ret || track.artist.contains(textSearch)
//        }
//        return ret
//    }
//
    func stateChanged(state: SearchListJeuxState){
        #if DEBUG
        debugPrint("HomePageView -> searchList state : \(state)")
        debugPrint("HomePageView -> formViewOpen=\(searchListJeux.formViewOpen)")
        #endif
        switch state {
        case .newJeux:
            self.intent.jeuLoaded()
        default:
            break
        }
    }

    var body: some View {
//        stateChanged(state: searchPlaylist.playListState)
        return NavigationView{
            VStack{
                Text("Bienvenue sur l'app du fetival du jeu")
                Spacer()
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
                //if let name = jeu.titre_jeu { Text(name).font(.title2) }
                Text(jeu.titre_jeu)
                    .font(.headline)
                
            }
        }
    }
}

//struct ErrorView : View{
//    let state : SearchListJeuxState
//    var body: some View{
//        VStack{
//            Spacer()
//            switch state{
//            case .loading, .loaded:
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
//                    .scaleEffect(3)
//            case .loadingError(let error):
//                ErrorMessage(error: error)
//            default:
//                EmptyView()
//            }
//            if case let .loaded(data) = state{
//                Text("\(data.count) jeux trouvés!")
//            }
//            Spacer()
//        }
//    }
//}
//
//
//
//
//struct ErrorMessage : View{
//    let error :  Error
//    var body: some View{
//        VStack{
//            Text("Error in search request")
//                .errorStyle()
//            if let error = error  as? HttpRequestError {
//                Text("\(error.description)")
//                    .noteStyle()
//            }
//            else{
//                Text("Unknown error")
//                    .errorStyle()
//            }
//        }
//    }
//}


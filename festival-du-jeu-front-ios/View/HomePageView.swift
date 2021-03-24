

import SwiftUI
import Combine




struct HomePageView: View {
    
    @ObservedObject var searchListJeux : SearchListJeuxViewModel
    var intent : SearchListJeuxIntent
    init(searchListJeux: SearchListJeuxViewModel){
        self.searchListJeux = searchListJeux
        self.intent = SearchListJeuxIntent(listJeux: searchListJeux)
    }
    
    

    private var searchState : SearchListJeuxState{
        return self.searchListJeux.listJeuxState
    }
    
    @State var detailPresented : Bool = false
    @State var textSearch             = ""
    
    
    var jeux : [JeuViewModel] {
        return self.searchListJeux.jeux
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


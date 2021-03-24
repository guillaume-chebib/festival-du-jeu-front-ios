
import SwiftUI

struct MainView: View {
    /// search list used by SearchListView
    @StateObject var listJeux : SearchListJeuxViewModel   = SearchListJeuxViewModel(ListJeux())

    /// which tab appear selected
    @State private var tabSelected  = 0
    
    var body: some View {
        TabView(selection: $tabSelected){
            HomePageView(searchListJeux: listJeux)
                .tabItem{
                    Text("Recherche")
                }.tag(0)
//            PersonalPlayListView(personalPlaylist: personalPlaylist)
//                .tabItem{
//                    Label("Playlist", systemImage: "list.dash")
//                }.tag(0)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(SearchListJeuxViewModel(ListJeux()))
    }
}

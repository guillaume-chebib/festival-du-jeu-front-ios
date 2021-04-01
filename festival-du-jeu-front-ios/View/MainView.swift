
import SwiftUI

struct MainView: View {
    /// search list used by SearchListView
    @StateObject var listJeux : SearchListJeuxViewModel   = SearchListJeuxViewModel(ListJeux())
    
    @StateObject var listEditeurs : SearchListEditeurViewModel   = SearchListEditeurViewModel(ListEditeur())
    
    @StateObject var listZones : SearchListZoneViewModel   = SearchListZoneViewModel(ListZone())


    /// which tab appear selected
    @State private var tabSelected  = 0
    
    var body: some View {
        TabView(selection: $tabSelected){
            HomePageView(searchListJeux: listJeux)
                .tabItem{
                    Label("Jeux", systemImage: "rectangle.and.text.magnifyingglass")
                }.tag(0)
            ListEditeurView(searchListEditeurs: listEditeurs)
                .tabItem{
                    Label("Editeurs", systemImage: "list.dash")
                }.tag(1)
            ListZoneView(searchListZones: listZones)
                .tabItem{
                    Label("Zones", systemImage: "location")
                }.tag(2)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(SearchListJeuxViewModel(ListJeux()))
    }
}

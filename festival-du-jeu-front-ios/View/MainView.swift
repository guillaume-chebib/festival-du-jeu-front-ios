
import SwiftUI

struct MainView: View {
    /// search list used by SearchListView
    @StateObject var listJeux : SearchListJeuxViewModel   = SearchListJeuxViewModel(ListJeux())

    /// which tab appear selected
    @State private var tabSelected  = 0
    
    var body: some View {
        HomePageView(searchListJeux: listJeux)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(SearchListJeuxViewModel(ListJeux()))
    }
}

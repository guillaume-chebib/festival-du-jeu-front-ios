

import SwiftUI
import Combine




struct ListZoneView: View {
    
    
    @ObservedObject var searchListZones : SearchListZoneViewModel
    var intent : SearchListZoneIntent
    
    var listeJeux : ListJeux
    init(searchListZones: SearchListZoneViewModel){
        self.searchListZones = searchListZones
        listeJeux = ListJeux()
        self.intent = SearchListZoneIntent(listZones: searchListZones)
        print("nouvelle vue")
        if case .ready = self.searchListZones.listZonesState {
        self.intent.loadListeZones()
        }
            
    }
    
    
    private var searchState : SearchListZonesState{
        return self.searchListZones.listZonesState
    }
    
    var zones : [ZoneViewModel] {
        return self.searchListZones.zones
    }
    
    
    
    @State private var text: String = ""

    @State private var isEditing = false
    
    
    func filterSearch(zone: ZoneViewModel) -> Bool {
        
        var res: Bool = true
        
        if (!text.isEmpty) {
            res = zone.nom_zone.lowercased().contains(text.lowercased())
        }
                
        return res
    }

    
    var body: some View {
        
        return NavigationView{
            VStack{
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

        ZStack{
            List{
                ForEach(self.searchListZones.zones.filter(filterSearch)){ zone in
                    NavigationLink(destination: ListJeuView(jeux: zone.jeux_zone)
                    )
                    {
                        ZoneRow(zone: zone)
                    }
                    
                }
            }
            if zones.count == 0{
                VStack{
                    Spacer()
                    Text("Aucune zone disponible")
                    Spacer()
                }
            }
        }
            }
        
        .navigationTitle("Zones")
    }
    .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ListZoneView_Previews: PreviewProvider {
    static var previews: some View {
        ListZoneView(searchListZones: SearchListZoneViewModel(ListZone()))
        
    }
}


struct ZoneRow : View{
    let zone : ZoneViewModel
    var body: some View{
        HStack{
            VStack(alignment: .leading){
                Text("\(zone.nom_zone)")
                    .font(.headline)
            }
        }
    }
}

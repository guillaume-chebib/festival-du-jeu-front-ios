

import SwiftUI
import Combine




struct ListEditeurView: View {
    
    
    @ObservedObject var searchListEditeurs : SearchListEditeurViewModel
    var intent : SearchListEditeurIntent
    
    var listeJeux : ListJeux
    init(searchListEditeurs: SearchListEditeurViewModel){
        self.searchListEditeurs = searchListEditeurs
        listeJeux = ListJeux()
        self.intent = SearchListEditeurIntent(listEditeurs: searchListEditeurs)
        print("nouvelle vue")
        if case .ready = self.searchListEditeurs.listEditeursState {
        self.intent.loadListeEditeurs()
        }
            
    }
    
    
    private var searchState : SearchListEditeursState{
        return self.searchListEditeurs.listEditeursState
    }
    
    var editeurs : [EditeurViewModel] {
        return self.searchListEditeurs.editeurs
    }
    
    
    
    @State private var text: String = ""

    @State private var isEditing = false
    
    
    func filterSearch(editeur: EditeurViewModel) -> Bool {
        
        var res: Bool = true
        
        if (!text.isEmpty) {
            res = editeur.nom_editeur.lowercased().contains(text.lowercased())
        }
                
        return res
    }

    
    var body: some View {
        
        return NavigationView{
            VStack{
                HStack {
                    Button(action: {
                            self.intent.loadListeEditeurs()}){
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

        ZStack{
            List{
                ForEach(self.searchListEditeurs.editeurs.filter(filterSearch)){ editeur in
                    NavigationLink(destination: ListJeuView(jeux: editeur.jeux_editeur)
                    )
                    {
                        EditeurRow(editeur: editeur)
                    }
                    
                }
            }
            if editeurs.count == 0{
                VStack{
                    Spacer()
                    Text("Aucun editeur disponible")
                    Spacer()
                }
            }
            ErrorViewEditeurs(state: searchState)
        }
            }
        
        .navigationTitle("Editeurs")
    }
    .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ListEditeurView_Previews: PreviewProvider {
    static var previews: some View {
        ListEditeurView(searchListEditeurs: SearchListEditeurViewModel(ListEditeur()))
        
    }
}


struct EditeurRow : View{
    let editeur : EditeurViewModel
    var body: some View{
        HStack{
            VStack(alignment: .leading){
                Text("\(editeur.nom_editeur)")
                    .font(.headline)
            }
        }
    }
}

struct ErrorViewEditeurs : View{
    let state : SearchListEditeursState
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
                Text("\(data.count) editeurs trouvés!")
            }
            Spacer()
        }
    }
}

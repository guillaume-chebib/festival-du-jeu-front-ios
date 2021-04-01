
import SwiftUI
import Combine




struct ListJeuView: View {
    
    var jeux : [Jeu]
    
    init(jeux:[Jeu]){
        self.jeux = jeux
    }
    
    
    
    
    var body: some View {

        ZStack{
            List{
                ForEach(self.jeux){ jeu in
                    NavigationLink(destination: JeuView(jeu: jeu)){
                        Text(jeu.titre_jeu)
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
        }
    }
}

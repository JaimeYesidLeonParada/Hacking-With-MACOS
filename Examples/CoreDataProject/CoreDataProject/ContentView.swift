//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Jaime Yesid Leon Parada on 22/07/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>
    
    
    var body: some View {
        VStack{
            List{
                ForEach(countries) { country in
                    Section(country.countryFullName) {
                        ForEach(country.countryCandy) { candy in
                            Text(candy.candyName)
                        }
                    }
                }
            }
            
            Button("Add Examples") {
                let candy1 = Candy(context: managedObjectContext)
                candy1.name = "Mars"
                candy1.origin = Country(context: managedObjectContext)
                candy1.origin?.shortName = "UK"
                candy1.origin?.fullName = "United Kingdom"
                
                let candy2 = Candy(context: managedObjectContext)
                candy2.name = "KitKat"
                candy2.origin = Country(context: managedObjectContext)
                candy2.origin?.shortName = "UK"
                candy2.origin?.fullName = "United Kingdom"
                
                let candy3 = Candy(context: managedObjectContext)
                candy3.name = "Twix"
                candy3.origin = Country(context: managedObjectContext)
                candy3.origin?.shortName = "UK"
                candy3.origin?.fullName = "United Kingdom"
                
                let candy4 = Candy(context: managedObjectContext)
                candy4.name = "Toblerone"
                candy4.origin = Country(context: managedObjectContext)
                candy4.origin?.shortName = "CH"
                candy4.origin?.fullName = "Switzerland"
                
                try? managedObjectContext.save()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

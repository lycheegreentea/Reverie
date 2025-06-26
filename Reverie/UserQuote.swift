//
//  UserQuote.swift
//  Reverie
//
//  Created by Lauren Chen on 6/26/25.
//

import SwiftUI

struct UserQuote: View {
    var body: some View {

        NavigationView {
            NavigationLink(destination: Text("HI")) { Text("New Quote") }
            .navigationBarTitle("User Quotes")
            
        }
        
        }
    }


#Preview {
    UserQuote()
}

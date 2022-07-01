//
//  AddView.swift
//  AppWithDB
//
//  Created by user on 30/06/22.
//

import SwiftUI

struct AddView: View {
    //Inizializzo le variabili
    @State var noteTitle : String = ""
    @State var noteContent : String = ""
    
    //serve per poter tornare alla precedente view
    @Environment(\.presentationMode) var mode : Binding<PresentationMode>
    
    var body: some View {
        VStack{
            TextField("Enter note title", text: $noteTitle)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)
            
            TextField("Enter your note", text: $noteContent)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)
            
            Button(action:{
                //richiama la funzione aggiungi nota e la mette dentro il db
                DB_Manager().addNote(self.noteTitle, self.noteContent)
                //fa tornare alla home page
                self.mode.wrappedValue.dismiss()
            }, label: {
                Text("Add note")})
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
        .padding()
    }
}


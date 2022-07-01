//
//  EditView.swift
//  AppWithDB
//
//  Created by user on 30/06/22.
//

import Foundation
import SwiftUI

struct EditView: View {
    
    //inizializzo variabili
    @Binding var id : Int64
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
            
            Button(action: {
                //richiama la funzione modifica nota e la modifica anche dentro il db
                DB_Manager().updateNote(self.id, self.noteTitle, self.noteContent)
                
                //fa tornare alla home page
                self.mode.wrappedValue.dismiss()
            }, label: {
               Text("Edit note")})
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
        .padding()
        
        //quando viene visualizzata la view
        .onAppear(perform: {
            
            //acquisisce i dati dal database
            let noteModel : MyNote = DB_Manager().getNote(idValue : self.id)
            self.noteTitle = noteModel.noteTitle
            self.noteContent = noteModel.noteContent
        })
    }
}

struct EditView_Previews : PreviewProvider{
    
    @State static var id : Int64 = 0
    
    static var previews: some View {
        EditView(id: $id)
    }
}

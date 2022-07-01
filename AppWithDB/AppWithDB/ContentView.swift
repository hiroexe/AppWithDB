//
//  ContentView.swift
//  AppWithDB
//
//  Created by user on 30/06/22.
//

import SwiftUI

struct ContentView: View {
    
    //controllo se la nota è stata selezionata per essere modificata
    @State var selectedNote : Bool = false
    
    //id della nota selezionata
    @State var selectedNoteId : Int64 = 0
    
    //array di modelli note
    @State var notesModel : [MyNote] = []
    
    var body: some View {
        
        //creo una lista per mostrare le note
        List(self.notesModel) { (model) in
            
            HStack{
                Text(model.noteTitle)
                Spacer()
                Text(model.noteContent)
                
                //bottoni per la modifica e l'eliminazione
                //modifica
                /*
                 .buttonStyle(PlainButtonStyle())
                
                */
            }.swipeActions{
                Button(action: {
                    
                    //creo l'istanza del db manager
                    let dbManager : DB_Manager = DB_Manager()
                    
                    //chiamo la funzione di eliminazione
                    dbManager.deleteNote(model.id)
                    
                    //aggiorna l'array dei modelli note
                    self.notesModel = dbManager.getNotes()
                }, label: {
                    Label("Delete", systemImage : "minus.circle")
                }).tint(.red)
                
                Button(action: {
                    self.selectedNoteId = model.id
                    self.selectedNote = true
                    
                    print("EDITING NOTES")
                }, label: {
                    Text("Edit")
                        
                })
            }
        }
        
        
        //creo navigtion view
        NavigationView{
            VStack {
                //crea link per aggiungere la nota
                HStack{
                    Spacer()
                    NavigationLink(destination: AddView(), label: {
                        Label("", systemImage: "square.and.pencil")
                    })
                    
                    NavigationLink(destination: EditView(id: self.$selectedNoteId), isActive : self.$selectedNote){
                        EmptyView()
                    }
                }
            }.padding()
                .navigationBarTitle("Actions")
            //carica i dati nell'array contente i modelli delle note
                .onAppear(perform: {
                    self.notesModel = DB_Manager().getNotes()
                })
        }.frame(height: 200)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


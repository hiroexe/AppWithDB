//
//  DB_Manager.swift
//  AppWithDB
//
//  Created by user on 30/06/22.
//

import Foundation
import SQLite

class DB_Manager {
    //Instanzia database
    private var db: Connection!
    
    //istanza tabella del database
    private var notes: Table!
    
    //Istanza colonne tabella
    private var id : Expression<Int64>!
    private var noteTitle : Expression<String>!
    private var noteContent : Expression<String>!
    
    //costruttore classe
    init() {
        do {
            //cerca il path della cartella del database
            let path : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            
            //crea connessione con il database
            db = try Connection("\(path)/my_notes.sqlite3")
            
            //crea oggetto tabella
            notes = Table("Notes")
            
            //creazione istanza di ogni colonna
            id = Expression<Int64> ("id")
            noteTitle = Expression<String> ("Note Title")
            noteContent = Expression<String> ("Note Content")
            
            //Controlla se la tabella di questa nota è già stata creata
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
                
                //se non è stata creata
                try db.run(notes.create{(t) in
                    t.column(id, primaryKey: true)
                    t.column(noteTitle)
                    t.column(noteContent)
                })
                
                // setta il valore a true così non provera a crearla di nuovo
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
            
        } catch {
            //mostra il messaggio d'errore
            print(error.localizedDescription)
        }
    }
    
    public func addNote(_ noteTitleValue : String, _ noteContentValue : String) {
        if noteTitleValue != "" || noteContentValue != "" {
            do {
                try db.run(notes.insert(noteTitle <- noteTitleValue, noteContent <- noteContentValue))
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    //ritorna un array di note model
    public func getNotes() -> [MyNote] {
        
        //creazione array vuoto
        var notesModel : [MyNote] = []
        
        //prendo tutte le note in ordine decrescente
        notes = notes.order(id.desc)
        
        //gestione dell'eccezioni
        do{
            //loop su tutte le note
            for temp in try db.prepare(notes){
                //creo un nuovo modello per ogni iterazione del ciclo
                let noteModel : MyNote = MyNote()
                
                //setta i valori in model dal database
                noteModel.id = temp[id]
                noteModel.noteTitle = temp[noteTitle]
                noteModel.noteContent = temp[noteContent]
                
                //aggiungilo nell'array
                notesModel.append(noteModel)
                
            }
        } catch {
            print(error.localizedDescription)
        }
        //ritorno il mio array
        return notesModel
    }
    
    //prende una singola nota
    public func getNote(idValue: Int64) -> MyNote {
        
        //creo oggetto vuoto
        let noteModel : MyNote = MyNote()
        
        //gestione dell'eccezione
        do {
            let temp : AnySequence<Row> = try db.prepare(notes.filter(id == idValue))
            
            try temp.forEach({(rowValue) in
                
                //setta i valori nel modello
                noteModel.id = try rowValue.get(id)
                noteModel.noteTitle = try rowValue.get(noteTitle)
                noteModel.noteContent = try rowValue.get(noteContent)
            })
        } catch {
            print(error.localizedDescription)
        }
        
        //ritorno del modello
        return noteModel
    }
    
    //funzione per aggiornare la nota
    public func updateNote (_ idValue : Int64, _ noteTitleValue : String, _ noteContentValue : String) {
        
        do{
            //trova la nota tramite l'id
            let temp : Table = notes.filter( id == idValue)
            
            //fai partire l'aggiornamento della query
            try db.run(temp.update(noteTitle <- noteTitleValue, noteContent <- noteContentValue))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //funzione per cancellare una nota
    public func deleteNote(_ idValue : Int64) {
        do {
            let temp : Table = notes.filter(id == idValue)
            
            //fai partire la cancellazione della query
            try db.run(temp.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
}

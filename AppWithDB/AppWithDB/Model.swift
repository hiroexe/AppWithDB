//
//  Model.swift
//  
//
//  Created by user on 30/06/22.
//

import Foundation


//Dichiarazione classe contentente la nota
class MyNote : Identifiable {
    public var id : Int64 = 0
    public var noteTitle : String = ""
    public var noteContent : String = ""
}

//
//  manageRoutes.swift
//  School Bus Route Software
//
//  Created by Alvin Wu on 2024-04-03.
//

import SwiftUI
import MapKit
import SQLite
import Vapor

struct ContentView: SwiftUI.View {
    
}

struct ContentView_Provider: PreviewProvider {
    static var previews: some SwiftUI.View {
        ContentView()
    }
}

func getAddress(orderQuery: Int) -> String {
    var queriedAddress = "none"
    
    print("Entering getAddress")
    
    do {
        let dbPath = "addresses.db"
//        let dbPath = "/Users/alvinwu/Documents/School Bus Route Software/School Bus Route Software/Databases/accounts.db"
        print("dbPath: \(dbPath)")
        let db = try Connection(dbPath, readonly: true)
//        let db = openDb()
        
        print("Connection: \(db)")

        let addresses = Table("addresses")
        let count = addresses.count
        print("addresses.count: \(count)")
        
        let order = Expression<Int>("order")
        let address = Expression<String>("address")
        
//        try db.run(accounts.create(ifNotExists: true) { t in
//            t.column(username)
//            t.column(hash)
//        })
        
//        let insert = accounts.insert(username <- "test1", hash <- "test2")
//        try db.run(insert)
        
        // SELECT address FROM addresses WHERE order = orderQuery
        let query = addresses.select(address).filter(order == orderQuery)

        // for each address in try db.prepare(query)
        for item in try db.prepare(query) {
            print(address)
            queriedAddress = item[address]
        }

        print(addresses)
        print(query)
        
        
    } catch {
        print(error)
    }
    
    return(queriedAddress)
}

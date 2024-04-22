import SwiftUI
import SQLite3
import SQLite
import CryptoKit
import Vapor
import Fluent

struct LoginView: SwiftUI.View {
    
    @State var name: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    
    var types = ["Admin", "BusPersonnel", "ParentStudent"]
    @State var selectedType: String = "admin"
    @State var accountType: String = "admin"
    
    var isSignInButtonDisabled: Bool {
        [name, password].contains(where: \.isEmpty)
    }
    
    var body: some SwiftUI.View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("School Bus Route Software")
                .font(.title)
                .multilineTextAlignment(.center)
                .bold()
            
            Text("Student transportation route management software")
                .multilineTextAlignment(.center)
            
            TextField("Name",
                      text: $name ,
                      prompt: Text("Login").foregroundColor(.blue)
            )
            .padding(10)
            .padding(.horizontal)

            HStack {
                Group {
                    if showPassword {
                        TextField("Password", // how to create a secure text field
                                    text: $password,
                                    prompt: Text("Password").foregroundColor(.red)) // How to change the color of the TextField Placeholder
                    } else {
                        SecureField("Password", // how to create a secure text field
                                    text: $password,
                                    prompt: Text("Password").foregroundColor(.red)) // How to change the color of the TextField Placeholder
                    }
                }
                .padding(10)

                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.red) // how to change image based in a State variable
                }

            }.padding(.horizontal)

            Button {
                // login action
                print(getHash(forUsername: "3006031@edison.k12.nj.us"))
                print(getSalt(forUsername: "3006031@edison.k12.nj.us"))
                
            } label: {
                Text("Sign In")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity) // how to make a button fill all the space available horizontaly
            .background(
                isSignInButtonDisabled ? // how to add a gradient to a button in SwiftUI if the button is disabled
                LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing) :
                    LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .cornerRadius(20)
            .disabled(isSignInButtonDisabled) // how to disable while some condition is applied
            .padding()
            }
        
        }
    
}

// Accounts database shenanigans

func openAccounts() -> OpaquePointer? {
    let fileURL = try! FileManager.default
        .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("accounts.sqlite")
    
    var db: OpaquePointer?
    if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
        return db
    }
    else {
        print("error opening database")
        sqlite3_close(db)
        db = nil
        return db
    }
}

func getHash(forUsername usernameQuery: String) -> String {
    var queriedHash = "none"
    
    do {
        let dbPath = "accounts.db" // Replace this with the actual path to your SQLite database file
        let db = try Connection(dbPath)
        
        let accounts = Table("accounts")
        let username = Expression<String>("username")
        let hash = Expression<String>("hash")
        let salt = Expression<String>("salt")
        let affiliation = Expression<String>("affiliation")
        let type = Expression<String>("type")
        
//        try db.run(accounts.create { t in
//            t.column(username)
//            t.column(hash)
//        })
        
        // SELECT hash FROM accounts WHERE username = '3006031@edison.k12.nj.us'
        let query = accounts.select(username, hash)
                            .filter(username == usernameQuery)
        
        let rowIterator = try db.prepareRowIterator(query)
        for user in try Array(rowIterator) {
            print(user[hash])
            queriedHash = user[hash]
        }
        
//        for user in try db.prepare(query) {
//            print(user[hash])
//            queriedHash = user[hash]
//        }
        
        
    } catch {
        print(error)
    }
    
    return(queriedHash)
}

func getSalt(forUsername username: String) -> String {
    let dbPath = "accounts.db" // Replace this with the actual path to your SQLite database file
    guard let db = try? Connection(dbPath) else {
        print("Error connecting to database")
        return "GAH"
    }
    
    let accounts = Table("accounts")
    let hashColumn = Expression<String>("hash")
    let saltColumn = Expression<String>("salt")
    let usernameColumn = Expression<String>("username")
    
    do {
        let query = accounts.select(hashColumn, saltColumn)
                            .filter(usernameColumn == username)
        
        for row in try db.prepare(query) {
            let salt = row[saltColumn]
            return salt
        }
    } catch {
        print("Error executing query: \(error)")
    }
    
    return "getSalt done"
}

func login(username: String, password: String) -> Bool {
    
    
    let hash = getHash(forUsername: username)
    let salt = getSalt(forUsername: username)
    
    let pwCombined = password + salt
    
    let data = pwCombined.data(using: .utf8)
    
    let optionalData: Data? = data
    processData(optionalData!)
    
    let pwHashed = String(bytes: CryptoKit.SHA256.hash(data: data!), encoding: .utf8)
    
    // Compare pwHashed with hash on file
    if pwHashed == hash {
        return true
    }
    else {
        return false
    }
}

func processData(_ optionalData: Data?) {
    if let data = optionalData {
        print("Data received: \(data)")
    } else {
        print("No data received")
    }
}

struct ContentView_Previews: SwiftUI.PreviewProvider {
    static var previews: some SwiftUI.View {
        LoginView()
    }
}

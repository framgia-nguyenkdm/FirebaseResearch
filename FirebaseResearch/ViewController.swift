//
//  ViewController.swift
//  FirebaseResearch
//
//  Created by Khuc Dinh Minh Nguyen on 4/24/19.
//  Copyright © 2019 Khuc Dinh Minh Nguyen. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, AuthUIDelegate {
    private var documents: [DocumentSnapshot] = []
    private var listener: ListenerRegistration!
    var cities: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListCities()
        observerListCities(limit: 20)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.listener.remove()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let ref = Firestore.firestore().collection("Cities")
        
        ref.document("DNJS123jsns32knd").setData([
            "id": "1",
            "images": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHPNKXqZwUOqKrG-TCDxyMxSkUfFO28MyaVSd-AYNWQeoQUx55",
            "name": "Viet Nam",
            "population": 98000000,
            "visited": true
            ])
    }
    @IBAction func reconnectTapped(_ sender: Any) {
        Firestore.firestore().enableNetwork { (error) in
        
        }
        
    }
    @IBAction func disconnectTapped(_ sender: Any) {
        Firestore.firestore().disableNetwork { (error) in
            
        }
    }
    
}


extension ViewController {
    func getListCities() {
        let database = Firestore.firestore()
        let query = database.collection("Cities")
        
        query.whereField("name", isEqualTo: "VietNam")
            .getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                print("Empty database")
                return
            }
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            let data = snapshot.documents.map({ (document) -> City in
                if let city = City(dictionary: document.data(), id: document.documentID) {
                    return city
                } else {
                    fatalError("Unable to initialize type \(City.self) with dictionary \(document.data())")
                }
            })
            
            self.cities = data
            print("Nguyen fetch data: \(self.cities)")
        }
    }
    
    func observerListCities(limit: Int?) {
        let db = Firestore.firestore()
        let query: Query
        if let limit = limit {
            query = db.collection("Cities")
                .limit(to: limit)
        } else {
            query = db.collection("Cities")
        }
        self.listener = query.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            // change data from snapshot
//            snapshot.documentChanges.forEach({ (diff) in
//                if (diff.type == .added) {
//                    print("New city: \(diff.document.data())")
//                }
//                if (diff.type == .modified) {
//                    print("Modified city: \(diff.document.data())")
//                }
//                if (diff.type == .removed) {
//                    print("Removed city: \(diff.document.data())")
//                }
//            })
            
            
            let source = snapshot.metadata.hasPendingWrites ? "Local" : "Server"
            print("\(source) data)")
            let data = snapshot.documents.map({ (document) -> City in
                if let city = City(dictionary: document.data(), id: document.documentID) {
                    return city
                } else {
                    fatalError("Unable to initialize type \(City.self) with dictionary \(document.data())")
                }
            })
            
            self.cities = data
            self.documents = snapshot.documents
            print("Nguyen observer data data: \(self.cities)")
        })
    }
}


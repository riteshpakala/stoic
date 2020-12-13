//
//  Router.Backend.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/12/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import Firebase

extension ServiceCenter {
    public var backend: BackendService {
        .init()
    }
    
    public struct BackendService {
        
        public struct Core {
            public static var main: Database {
                Database.database(url: "https://stoic-45d04.firebaseio.com/")
            }
            public static var search: Database {
                Database.database(url: "https://stoic-45d04-searches-d90cb.firebaseio.com/")
            }
            public static var prediction: Database {
                Database.database(url: "https://stoic-45d04-predictions-3acae.firebaseio.com/")
            }
            
            public enum Files {
                case subscription
                case models
                
                public struct Receipts {
                    public static var subscription: StorageReference {
                        Storage.storage(url: "gs://stoic-45d04-receipts-us").reference().child("subscription")
                    }
                }
                
                public struct Models {
                    public static var root: StorageReference {
                        Storage.storage(url: "gs://stoic-45d04-models-us").reference()
                    }
                }
                
                var connect: StorageReference {
                    switch self {
                    case .subscription:
                        return BackendService.Core.Files.Receipts.subscription
                    case .models:
                        return BackendService.Core.Files.Models.root
                    }
                }
            }
                
            public enum Server {
                case main
                case search
                case prediction
                
                var connect: DatabaseReference {
                    switch self {
                    case .main:
                        return BackendService.Core.main.reference()
                    case .search:
                        return BackendService.Core.search.reference()
                    case .prediction:
                        return BackendService.Core.prediction.reference()
                    }
                }
            }
        }
        
        public func putFile(
            _ data: URL,
            filename: String,
            key: String? = nil,
            storage: Core.Files,
            completion: @escaping ((Bool) -> Void)) {
            
            storage.connect.child((key != nil ? "/\(key!)/" : "")+filename).putFile(
                from: data,
                metadata: nil,
                completion: { (metaData, error) in
                    completion(error == nil)
            })
        }
        
        public func putData(
            _ data: Data,
            filename: String,
            key: String? = nil,
            storage: Core.Files,
            completion: @escaping ((Bool) -> Void)) {
            
            
            storage.connect.child((key != nil ? "/\(key!)/" : "")+filename).putData(
                data,
                metadata: nil,
                completion: { (metaData, error) in
                    completion(error == nil)
            })
        }
        
        public func getData(
            _ key: String,
            filename: String,
            storage: Core.Files,
            completion: @escaping ((Data?, Bool) -> Void)) {
            
            storage.connect.child("/\(key)/\(filename)").getData(maxSize: Int64.max) { data, error in
                completion(data, error == nil)
            }
        }
        
        public func getData(
            fromRef ref: StorageReference,
            completion: @escaping ((Data?, Bool) -> Void)) {
            
            ref.getData(maxSize: Int64.max) { data, error in
                completion(data, error == nil)
            }
        }
        
        public func getDataList(
            _ key: String,
            storage: Core.Files,
            completion: @escaping (([StorageReference], Bool) -> Void)) {
            
            storage.connect.child("/\(key)").listAll { (resultSpecific, error) in
                completion(resultSpecific.items, error == nil)
            }
        }
        
        public func put(
            _ data: BackendModel,
            route: Route,
            server: Core.Server = .main,
            key: String? = nil,
            permission: Route.Permission = .update) {
            
            switch permission {
            case .update:
                server.connect.child(
                    route.rawValue+(key != nil ? "/\(key!)" : ""))
                        .updateChildValues(data.backendModel)
            case .set:
                get(route: route, server: server, key: key) { existedData in
                    if existedData.isEmpty {
                        server.connect.child(
                            route.rawValue+(key != nil ? "/\(key!)" : ""))
                                .updateChildValues(data.backendModel)
                    }
                }
            case .overwrite:
                print("{BACKEND} overwrite is not setup yet")
            }
        }
        
        public func get(
            route: Route,
            server: Core.Server = .main,
            query: Route.Query? = nil,
            key: String? = nil,
            completion: @escaping (([[AnyHashable: Any]]) -> (Void))) {
            
            if let query = query {
                switch query {
                case .limitFirst(let limit):
                    server.connect.child(
                        route.rawValue+(key != nil ? "/\(key!)" : ""))
                        .queryLimited(toFirst: limit)
                        .observeSingleEvent(
                            of: .value,
                            with: { snapshot in
                         completion(BackendService.getValueFrom(snapshot))
                    })
                case .limitLast(let limit):
                    server.connect.child(
                        route.rawValue+(key != nil ? "/\(key!)" : ""))
                        .queryLimited(toLast: limit)
                        .observeSingleEvent(
                            of: .value,
                            with: { snapshot in
                         completion(BackendService.getValueFrom(snapshot))
                    })
                }
            } else {
                server.connect.child(
                    route.rawValue+(key != nil ? "/\(key!)" : ""))
                    .observeSingleEvent(
                        of: .value,
                        with: { snapshot in
                        completion(BackendService.getValueFrom(snapshot))
                })
            }
        }
        
        public static func getValueFrom(_ snapshot: DataSnapshot) -> [[AnyHashable : Any]] {
            if let data = snapshot.value as? [AnyHashable : Any] {
                return data.backendModel ?? [data]
            }else {
                return []
            }
        }
    }
}

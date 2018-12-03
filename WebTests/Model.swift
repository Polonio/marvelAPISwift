//
//  Model.swift
//  WebTests
//
//  Created by Dev1 on 30/11/2018.
//  Copyright © 2018 Dev1. All rights reserved.
//

import UIKit
import CoreData

struct RootJSON:Codable {
   let etag:String
   struct Data:Codable {
      let count:Int
      struct Results:Codable {
         let id:Int
         let title:String
         let issueNumber:Int
         let variantDescription:String
         let description:String?
         struct Prices:Codable {
            let type:String
            let price:Double
         }
         let prices:[Prices]
         struct Thumbnail:Codable {
            let path:URL
            let imageExtension:String
            enum CodingKeys:String, CodingKey {
               case path
               case imageExtension = "extension"
            }
            var fullPath:URL? {
               var pathComponents = URLComponents(url: path, resolvingAgainstBaseURL: false)
               pathComponents?.scheme = "https"
               return pathComponents?.url?.appendingPathComponent("portrait_incredible").appendingPathExtension(imageExtension)
            }
         }
         let thumbnail:Thumbnail
         struct Creators:Codable {
            let items:[Items]
            struct Items:Codable {
               let name:String
               let role:String
            }
         }
         let creators:Creators
      }
      let results:[Results]
   }
   let data:Data
}

var datosCarga:[RootJSON] = []
var etag:String?

func cargar(datos:Data) {
   print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
   //let consultaComics = NSFetchRequest<Comics> = Comics.fetchRequest()
//   let numComics = (try? context.count(for: consultaComics)) ?? 0
//   if numComics > 0 {
//      return
   //}
   
}

func recuperaURL(url:URL, callback:@escaping (UIImage) -> Void) {
   let conexion = URLSession.shared
   conexion.dataTask(with: url) { (data, response, error) in
      guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
         if let error = error {
            print("Error en la conexión de red \(error.localizedDescription)")
         }
         return
      }
      if response.statusCode == 200 {
         if let imagen = UIImage(data: data) {
            callback(imagen)
         }
      }
      }.resume()
}

var persistentContainer:NSPersistentContainer = {
   let container = NSPersistentContainer(name: "DatosComics")
   container.loadPersistentStores { (storeDescripcion, error) in
      if let error = error as NSError? {
         fatalError("Error inicialización de la base de datos")
      }
   }
   return container
}()

var context:NSManagedObjectContext {
   return persistentContainer.viewContext
}

//var datosCarga:RootJSON?
//var etag:String?

//func cargar(datos:Data) {
//   let decoder = JSONDecoder()
//   do {
//      datosCarga = try decoder.decode(RootJSON.self, from: datos)
//      UserDefaults.standard.set(datosCarga?.etag, forKey: "etag")
//      etag = datosCarga?.etag
//      NotificationCenter.default.post(name: NSNotification.Name("OKCARGA"), object: nil)
//   } catch {
//      print("Fallo en la serialización \(error)")
//   }
//}
//
//func recuperaURL(url:URL, callback:@escaping (UIImage) -> Void) {
//   let conexion = URLSession.shared
//   conexion.dataTask(with: url) { (data, response, error) in
//      guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
//         if let error = error {
//            print("Error en la conexión de red \(error.localizedDescription)")
//         }
//         return
//      }
//      if response.statusCode == 200 {
//         if let imagen = UIImage(data: data) {
//            callback(imagen)
//         }
//      }
//      }.resume()
//}

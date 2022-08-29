//
//  NetworkModel.swift
//  DragonBall
//
//  Created by Roberto Rojo Sahuquillo on 28/7/22.
//

import Foundation

// Creamos un network error personalizado
enum NetworkError: Error, Equatable {
    case malformedURL
    case dataFormatting
    case otherError
    case noData
    case errorCode(Int?)
    case tokenFormatError
    case decodingError
}

// Creamos la clase para las llamadas a red
class NetworkModel {
    // Creamos la session
    let session: URLSession
    
    let server = "https://vapor2022.herokuapp.com"
    // Creamos un atributo para guardar el token
    var token: String?
    // Creamos un singleton para que exista durante el uso de la aplicacion y solo en esta instancia que se llama asi misma
//    static let shared = NetworkModel()
//    private init() {}
    
    // Inicializamos la clase con la session y el token
    init(urlSession: URLSession = .shared, token: String? = nil) {
        self.session = urlSession
        self.token = token
    }
    
    // Para crear la funcion de logic debemos de fijarnos en las respuestas obtenidas en Postman sobre la API Rest
    func login(user: String, password: String,
               completion: @escaping (String?, NetworkError?) -> Void) {
        // Comprobamos la url
        guard let url = URL(string: "\(server)/api/auth/login") else {
            completion(nil, .malformedURL)
            return
        }
        //Transformamos el user y password a user:password
        //let loginString = user + ":" + password
        let loginString = String(format: "%@:%@", user, password)
        // Comprobamos el loginString
        guard let loginData = loginString.data(using: .utf8) else {
            completion(nil, .dataFormatting)
            return
        }
        // Tranformamos el loginData a base64
        let base64LoginString = loginData.base64EncodedString()
        // Hacemos el request al servidor con los datos del user en la cabecezera de autenticacion
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        // Creamos la tarea de llamada con la session
        let task = session.dataTask(with: urlRequest) { data, response, error in
            // Comprobamos que el error sea nil
            guard error == nil else{
                completion(nil, .otherError)
                return
            }
            // Comprobamos que no venga la data nil
            guard let data = data else{
                completion(nil, .noData)
                return
            }
            // Comprobamos que no venga un codigo de respuesta 200
            guard let httpResponse = (response as? HTTPURLResponse),
                  httpResponse.statusCode == 200 else {
                completion(nil, .errorCode((response as? HTTPURLResponse)?.statusCode))
                return
            }
            // Comprobamos que el token venga en formato correcto
            guard let token = String(data: data, encoding: .utf8) else {
                completion(nil, .tokenFormatError)
                return
            }
            
            // Pasamos el token al atributo para poder guardarlo
//            self.token = token
            //
            completion(token, nil)
        }
        task.resume()
    }

    func getHeroes (name: String = "", completion: @escaping ([Hero], NetworkError?) -> Void) {
        // Comprobamos la url
        guard let url = URL(string: "\(server)/api/heros/all") else {
            completion([], .malformedURL)
            return
        }
        
        guard let token = self.token else {
            completion([], .otherError)
            return
        }
        // Hacemos el request al servidor con los datos del user en la cabecezera de autenticacion
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        struct Body: Encodable {
            let name: String
        }
        let body = Body(name: name)
        
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            // Comprobamos que el error sea nil
            guard error == nil else{
                completion([], .otherError)
                return
            }
            // Comprobamos que no venga la data nil
            guard let data = data else{
                completion([], .noData)
                return
            }
            // Comprobamos que no venga un codigo de respuesta 200
            guard let httpResponse = (response as? HTTPURLResponse),
                  httpResponse.statusCode == 200 else {
                completion([], .errorCode((response as? HTTPURLResponse)?.statusCode))
                return
            }
            // Comprobamos que el token venga en formato correcto
            guard let heroesResponse = try? JSONDecoder().decode([Hero].self, from: data) else {
                completion([], .decodingError)
                return
            }
            // No nos interesa guardarlo localmente
            // self.token
            // Pasamos el token al atributo para poder guardarlo
            completion(heroesResponse, nil)
        }
        task.resume()
        
    }
    
//    func getTransformations (name: String = "", completion: @escaping ([Transformation], NetworkError?) -> Void) {
//    }
    
}

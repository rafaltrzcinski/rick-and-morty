//
//  NetworkManagerProtocol.swift
//  RickyBuggyBright
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func publisher(
        path: String,
        method: HttpMethod,
        timeout: TimeInterval
    ) -> AnyPublisher<Data, Error>
    
    func publisher(fromURLString urlString: String) -> Publishers.MapError<Publishers.MapKeyPath<Publishers.FlatMap<URLSession.DataTaskPublisher, Publishers.ReceiveOn<Publishers.SetFailureType<Optional<URL>.Publisher, URLError>, DispatchQueue>>, Data>, Error>
}

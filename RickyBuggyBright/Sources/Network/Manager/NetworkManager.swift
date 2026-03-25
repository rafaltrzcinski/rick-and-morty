//
//  NetworkManager.swift
//  RickyBuggyBright
//

import Foundation
import Combine

final class NetworkManager: NetworkManagerProtocol {
    
    static let RANDOM_HOST_NAME_TO_FAIL_REQUEST = "thisshouldfail.com"
    
    func publisher(
        path: String,
        method: HttpMethod = .get,
        timeout: TimeInterval = 5
    ) -> AnyPublisher<Data, Error> {
        var components = URLComponents()
        components.scheme = "https"
        // This is inteded, if you decide to move this code around please keep functionallity to random fail request
        components.host = Int.random(in: 1...10) > 3 ? "rickandmortyapi.com" : NetworkManager.RANDOM_HOST_NAME_TO_FAIL_REQUEST
        components.path = path
        
        guard let url = components.url else {
            return Fail(error: APIError(type: .buildingRequestFailed))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.httpMethod = method.rawValue

        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { $0 as Error }
            .map(\.data)
            .eraseToAnyPublisher()
    }
    
    func publisher(fromURLString urlString: String) -> Publishers.MapError<Publishers.MapKeyPath<Publishers.FlatMap<URLSession.DataTaskPublisher, Publishers.ReceiveOn<Publishers.SetFailureType<Optional<URL>.Publisher, URLError>, DispatchQueue>>, Data>, Error> {
        return Just(urlString)
            .compactMap(URL.init)
            .setFailureType(to: URLError.self)
            .receive(on: DispatchQueue.main)
            .flatMap(URLSession.shared.dataTaskPublisher(for:))
            .map(\.data)
            .mapError { $0 as Error }
    }
}

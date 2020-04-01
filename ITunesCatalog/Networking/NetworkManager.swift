import Foundation

protocol NetworkManagerProtocol {
    func performGetRequest(withURLRequest request: URLRequest, completion: @escaping HTTPCallback)
}

class NetworkManager: NetworkManagerProtocol {
    func performGetRequest(withURLRequest request: URLRequest, completion: @escaping HTTPCallback) {
        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                } else if let data = data {
                    completion(.success(data))
                }
            }.resume()
        }
    }

}

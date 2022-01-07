public struct Networker {
    var baseURL: String
    var networkDispatcher: NetworkDispatcher
    
    init(baseURL: String, networkDispatcher: NetworkDispatcher = NetworkDispatcher()) {
        self.baseURL = baseURL
        self.networkDispatcher = networkDispatcher
    }
}

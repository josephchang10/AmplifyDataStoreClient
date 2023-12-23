// The Swift Programming Language
// https://docs.swift.org/swift-book

import Combine
import Amplify
import Dependencies

struct DataStoreClient {
    var getReady: () async -> Void
}

extension DataStoreClient: DependencyKey {
    static var liveValue = {
        let manager = DataStoreManager()
        return Self(
            getReady: { await manager.getReady() }
        )
    }()
}

private class DataStoreManager {
    @Published var isReady = false
    private var hubListener: AnyCancellable?
    
    init() {
        setupDataStoreListener()
    }
    
    private func setupDataStoreListener() {
        hubListener = Amplify.Hub.publisher(for: .dataStore)
            .compactMap {
                $0.eventName == HubPayload.EventName.DataStore.ready ? true : nil
            }
            .assign(to: \.isReady, on: self)
    }
    
    func getReady() async {
        await withCheckedContinuation { continuation in
            if isReady {
                continuation.resume()
            } else {
                var cancellable: AnyCancellable? = nil
                cancellable = $isReady.sink { ready in
                    if ready {
                        continuation.resume()
                        cancellable?.cancel()
                    }
                }
            }
        }
    }
}

extension DependencyValues {
    var dataStore: DataStoreClient {
        get { self[DataStoreClient.self] }
        set { self[DataStoreClient.self] = newValue }
    }
}

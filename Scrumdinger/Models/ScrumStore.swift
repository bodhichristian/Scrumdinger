//
//  ScrumStore.swift
//  Scrumdinger
//
//  Created by christian on 1/7/23.
//

import Foundation

class ScrumStore: ObservableObject {
    @Published var scrums: [DailyScrum] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
            .appendingPathComponent("scrums.data")
    }
    static func load() async throws -> [DailyScrum] {
        // suspends the load function, then passes a continuation into the closure
        // a continuation is a vlaue that represents the code after an awaited function
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                    // on failure, send error to continuation closure
                case .failure(let error):
                    continuation.resume(throwing: error)
                    // on success, send scrums to continuation closure
                case .success(let scrums):
                    continuation.resume(returning: scrums)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[DailyScrum], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let dailyScrums = try JSONDecoder().decode([DailyScrum].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(dailyScrums))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // the save function returns a value that may not be used by the function caller
    // @discardableResult disables warnings about unused return values
    @discardableResult
    static func save(scrums: [DailyScrum]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(scrums: scrums) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let scrumsSaved):
                    continuation.resume(returning: scrumsSaved)
                }
            }
        }
    }
    
    static func save(scrums: [DailyScrum], completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(scrums)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(scrums.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
    }
}

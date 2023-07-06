import Foundation
import CoreLocation
import os.log

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: WEATER API MODEL

class WeatherApiModel {
    private let log = OSLog(subsystem: "com.nam.NamWeather", category: "Service Calls")

    func getApiURL(for url: String, parameters: [String: String]) async -> WeatherApiDataModel? {
        guard let unwrappedUrlComponents = URLComponents(string: url) else { return nil }

        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        var urlComponents = unwrappedUrlComponents
        urlComponents.queryItems = queryItems

        if let urlString = urlComponents.url {
            os_log("Making Service Call for %@", log: log, type: .info, urlString.absoluteString)
            do {
                guard let jsonData = try await makeCall(requestUrlString: urlString.absoluteString,
                                                        httpMethod: .get) else {
                    return nil
                }
                let weatherData = try JSONDecoder().decode(WeatherApiDataModel.self, from: jsonData)
                os_log("Weather info %@", log: log, type: .info,
                       String(describing: weatherData))
                return weatherData
            }
            catch let error {
                os_log("Service call for: %@ failed.", log: log, type: .error,
                       error.localizedDescription)
                return nil
            }
        }
        return nil
    }

    private func makeCall(requestUrlString: String,
                          httpMethod: HTTPMethod) async throws -> Data? {
        guard let requestURL = URL(string: requestUrlString) else {
            os_log("Failed to convert string @% to URL.", log: log, type: .error,
                   requestUrlString)
            return nil
        }

        var httpRequest = URLRequest(url: requestURL)
        httpRequest.httpMethod = httpMethod.rawValue

        do {
            let (data, _) = try await URLSession.shared.data(for: httpRequest)
            return data
        } catch let error {
            os_log("Service called failed: %@", log: log, type: .error, error.localizedDescription)
            return nil
        }
    }
}

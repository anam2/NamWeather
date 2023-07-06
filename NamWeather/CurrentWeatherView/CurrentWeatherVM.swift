import Foundation
import CoreLocation
import os.log

class CurrentWeatherVM: NSObject, ObservableObject {
    private let log = OSLog(subsystem: "com.nam.NamWeather", category: "CurrentWeatherVM")

    private static let defaultUrl = "https://api.open-meteo.com/v1/forecast"
    private static let gemOpenMeteoUrl = "https://api.open-meteo.com/v1/gem"

    private let locationManager: CLLocationManager
    private var weatherApiDataModel = WeatherApiDataModel()
    private var isLocationUpdated: Bool = false

    @Published var locationStatus: CLAuthorizationStatus?
    @Published var cityName: String = ""
    @Published var currentWeather = Weather()
    @Published var viewState: ViewState = .loading
    @Published var temperatureUnit: TemperatureUnit = .fahrenheit
    @Published var dailyWeather: DailyWeather = DailyWeather()
    @Published var hourlyWeather: HourlyWeather = HourlyWeather()

    override init() {
        locationManager = LocationManager().locationManager
        super.init()
        locationManager.delegate = self
    }

    func startUpdatingLocation() {
        os_log("Updating location...", log: log, type: .info)
        locationManager.startUpdatingLocation()
    }

    // MARK: Getters

    func getIndiciesForCurrentTime(quantity: Int) -> [Int] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:00"
        let currentDate = dateFormatter.string(from: Date())

        if let index = hourlyWeather.time.firstIndex(where: { $0 == currentDate }) {
            var timeIndicies = [Int]()
            for i in index...(index + quantity) {
                timeIndicies.append(i)
            }
            return timeIndicies
        } else {
            return []
        }
    }

    // MARK: Data Factoring

    private func getCorrectLongLatFormatForAPICall(_ locationDegree: CLLocationDegrees) -> CLLocationDegrees {
        return (locationDegree * 10_000).rounded() / 10_000
    }

    func convertWeatherDateTimeToDisplayTime(weatherDateTime: String) -> String {
        guard weatherDateTime.components(separatedBy: "T").count == 2 else { return "" }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        if let weatherTime = dateFormatter.date(from: weatherDateTime.components(separatedBy: "T")[1]) {
            dateFormatter.dateFormat = "h a"
            return dateFormatter.string(from: weatherTime)
        } else {
            return ""
        }
    }

    func convertStringDateToTextDate(stringDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: stringDate) else {
            return ""
        }

        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            return "Today"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        }
    }

    // MARK: Service Calls

    /// Get's information about the current location from API.
    func getCurrentWeather(currentLocation: CLLocation) async {
        let latitude = String("\(getCorrectLongLatFormatForAPICall(currentLocation.coordinate.latitude))")
        let longitude = String("\(getCorrectLongLatFormatForAPICall(currentLocation.coordinate.longitude))")
        let queryItems: [String: String] = [
            "longitude": longitude,
            "latitude": latitude,
            "temperature_unit": temperatureUnit.rawValue,
            "current_weather": "true",
            "daily": "apparent_temperature_max,apparent_temperature_min,weathercode",
            "timezone": "auto",
            "hourly": "apparent_temperature,weathercode"
        ]

        if let currentWeatherData = await WeatherApiModel().getApiURL(for: Self.defaultUrl, parameters: queryItems) {
            DispatchQueue.main.async {
                self.weatherApiDataModel = currentWeatherData
                self.currentWeather = currentWeatherData.currentWeather
                self.dailyWeather = currentWeatherData.dailyWeather
                self.hourlyWeather = currentWeatherData.hourlyWeather
            }
        }
    }

    func getCityName(for currentLocation: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first {
                guard let cityName = placemark.locality else { return }
                self.cityName = cityName
                print("City name: \(cityName)")
            }
        }
    }
}

extension CurrentWeatherVM: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard !isLocationUpdated, let location = locations.last else {
            isLocationUpdated = true
            manager.stopUpdatingLocation()
            return
        }

        Task {
            isLocationUpdated = true
            getCityName(for: location)
            await getCurrentWeather(currentLocation: location)
            manager.stopUpdatingLocation()
            DispatchQueue.main.async {
                self.viewState = .finished
            }
        }
    }
}

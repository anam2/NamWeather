struct WeatherIconHandler {
    func iconName(for intValue: Int) -> String {
        switch intValue {
        case 0:
            return "sun.max.fill"
        case 1, 2, 3:
            return "cloud.sun.fill"
        case 45, 48:
            return "cloud.fog.fill"
        case 51, 53, 55, 61, 63, 65:
            return "cloud.rain.fill"
        case 56, 57, 66, 67, 71, 73, 75, 77, 85, 86:
            return "cloud.snow.fill"
        case 80, 81, 82:
            return "cloud.bolt.rain.fill"
        default:
            return ""
        }
    }

    func iconDescription(for intValue: Int) -> String {
        switch intValue {
        case 0:
            return "Clear sky"
        case 1, 2, 3:
            return "Mainly clear, partly cloudy, and overcast"
        case 45, 48:
            return "Foggy"
        case 51, 53, 55:
            return "Drizzle"
        case 61, 63, 65:
            return "Raining"
        case 56, 57, 66, 67, 71, 73, 75, 77, 85, 86:
            return "Snow"
        case 80, 81, 82:
            return "Thunderstorm"
        default:
            return ""
        }
    }
}

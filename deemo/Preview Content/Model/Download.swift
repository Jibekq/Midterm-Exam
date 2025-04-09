import SwiftUI

struct Download: Identifiable {
    var id = UUID().uuidString
    var downloads: CGFloat
    var day: String
    var color: Color
}

var weekDownloads: [Download] = [
    Download(downloads: 1, day: "Mon", color: Color.green),
    Download(downloads: 5, day: "Tue", color: Color.green),
    Download(downloads: 6, day: "Wed", color: Color(red: 0.0, green: 0.5, blue: 0.0)),
    Download(downloads: 3, day: "Thu", color: Color.green),
    Download(downloads: 9, day: "Fri", color: Color(red: 0.0, green: 0.5, blue: 0.0)),
    Download(downloads: 2, day: "Sat", color: Color.green),
    Download(downloads: 8, day: "Sun", color: Color(red: 0.0, green: 0.5, blue: 0.0))
]

// Function to calculate worked hours
func calculateWorkedHours() -> (totalWorkedHours: Double, environmentHours: Double, peopleHours: Double) {
    // Calculate the total worked hours from the week's downloads
    let totalDownloads = weekDownloads.reduce(0) { $0 + $1.downloads }
    let totalWorkedHours = Double(totalDownloads)

    // Split the total hours between People (Mon-Wed) and Environment (Thu-Sun)
    var peopleDownloads = 0
    var environmentDownloads = 0

    for (index, download) in weekDownloads.enumerated() {
        if index <= 2 { // Monday to Wednesday (People)
            peopleDownloads += Int(download.downloads)
        } else { // Thursday to Sunday (Environment)
            environmentDownloads += Int(download.downloads)
        }
    }

    let peopleHours = Double(peopleDownloads)
    let environmentHours = Double(environmentDownloads)

    return (totalWorkedHours, environmentHours, peopleHours)
}

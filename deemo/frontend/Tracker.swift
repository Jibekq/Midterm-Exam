import SwiftUI

struct Tracker: View {
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var totalWorkedHours: Double = 0.0
    @State private var environmentHours: Double = 0.0
    @State private var peopleHours: Double = 0.0
    @State private var isGraphVisible = false  // Track visibility of the bar graph
    @State private var isLoading = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                // Header
                HStack(spacing: 15) {
                    
                    Spacer()
                    Button {
                        // Action for profile picture
                    } label: {
                        Image("Profile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                    }
                }
                .foregroundColor(.black)
                
                // Download stats
                DownloadStats()

                // Followers stats
                FollowersStats()
            }
            .padding(15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            calculateWorkedHoursAndUpdate() // Calculate hours when the profile view appears
        }
    }

    func calculateWorkedHoursAndUpdate() {
        isLoading = true
        
        // Get the calculated worked hours from the `Download.swift`
        let hours = calculateWorkedHours()

        self.totalWorkedHours = hours.totalWorkedHours
        self.environmentHours = hours.environmentHours
        self.peopleHours = hours.peopleHours

        isLoading = false
    }

    @ViewBuilder
    func FollowersStats() -> some View {
        VStack {
            HStack {
                Button {
                    // Action when SYM button is clicked
                } label: {
                    Text("SYM")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray)
                        )
                }
                .padding(.trailing, 10)

                Image(systemName: "person.3.fill")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(6)
                    .background(Color.green)
                    .cornerRadius(8)

                Text("Environment")
                    .font(.callout)
                    .foregroundColor(.black)
                    .padding(.trailing, 10)

                Image(systemName: "globe")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(6)
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(8)

                Text("People")
                    .font(.callout)
                    .foregroundColor(.black)
                    .padding(.trailing, 10)
            }
            
            VStack(spacing: 15) {
                Text(String(format: "%.1f hours", totalWorkedHours))
                    .font(.largeTitle.bold())
                    .scaleEffect(1.25)
                    .foregroundColor(.black)
                
                Text("Worked Hours in this week")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .padding(.top, 25)

            // Showing environment and people hours in the second frame
            HStack(spacing: 10) {
                StatButton(title: "Environment", count: String(format: "%.1f hours", environmentHours), icon: "globe", color: Color.green)
                StatButton(title: "People", count: String(format: "%.1f hours", peopleHours), icon: "person.3.fill", color: Color.blue.opacity(0.7))
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity)
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 5)
        )
    }

    @ViewBuilder
    func StatButton(title: String, count: String, icon: String, color: Color) -> some View {
        Button(action: {}) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .font(.caption.bold())
                        .foregroundColor(.black)
                        .padding(6)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                    Spacer()
                }
                Text(title)
                    .font(.caption)
                    .foregroundColor(.black)
                Text(count)
                    .font(.title2.bold())
                    .foregroundColor(.black)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(color)
            .cornerRadius(15)
        }
    }

    @ViewBuilder
    func DownloadStats() -> some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Working Hours")
                        .foregroundColor(.black)
                        .font(.title)
                        .fontWeight(.semibold)
                }
                Spacer()
                Button {
                    // Toggle the visibility of the bar graph when clicked
                    isGraphVisible.toggle()
                } label: {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.title2.bold())
                }
                .foregroundColor(.black)
            }

            HStack {
                Text(String(format: "%.1f hours", totalWorkedHours))
                    .font(.largeTitle.bold())
                    .foregroundColor(.black)
                Spacer()
                Button {
                    // Action when the Download button is clicked
                } label: {
                    Text("Download")
                        .font(.callout)
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                        )
                }
            }
            .padding(.vertical, 10)

            // Bar Graph with Gestures (only show if isGraphVisible is true)
            if isGraphVisible {
                BarGraph(downloads: weekDownloads) // Using your existing BarGraph view
                    .padding(.top, 25)
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .padding(.vertical, 20)
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()

        Tracker().environmentObject(authViewModel)
    }
}


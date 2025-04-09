import SwiftUI

struct BarGraph: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var downloads: [Download]
    
    // Gesture Properties
    @GestureState var isDragging: Bool = false
    @State var offset: CGFloat = 0
    
    // Current download to highlight while dragging
    @State var currentDownloadID: String = " "
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(downloads) { download in
                CardView(download: download)
                    .onTapGesture {
                        // When the bar is tapped, show the number for that specific bar
                        self.currentDownloadID = download.id
                    }
            }
        }
        .frame(height: 125)
        .animation(.easeOut, value: isDragging)
        // Gesture to handle dragging
        .gesture(
            DragGesture()
                .updating($isDragging, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    offset = isDragging ? value.location.x : 0
                    
                    // Get width dynamically
                    let screenWidth = value.startLocation.x
                    
                    let draggingSpace = screenWidth - 60
                    let eachBlock = draggingSpace / CGFloat(downloads.count)
                    
                    let temp = Int(offset / eachBlock)
                    
                    let index = max(min(temp, downloads.count - 1), 0)
                    
                    self.currentDownloadID = downloads[index].id
                })
                .onEnded({ value in
                    withAnimation {
                        offset = .zero
                        currentDownloadID = " " // Reset after drag ends
                    }
                })
        )
    }
    
    @ViewBuilder
    func CardView(download: Download) -> some View {
        VStack(spacing: 20) {
            GeometryReader { proxy in
                let size = proxy.size
                RoundedRectangle(cornerRadius: 6)
                    .fill(download.color)
                    .opacity(isDragging ? (currentDownloadID == download.id ? 1 : 0.35) : 1)
                    .frame(height: (download.downloads / getMax()) * (size.height))
                    .overlay(
                        Text("\(Int(download.downloads))")
                            .font(.callout)
                            .foregroundColor(.black)
                            .opacity(currentDownloadID == download.id ? 1 : 0) // Show number only if the ID matches the tapped one
                            .offset(y: -30),
                        alignment: .top
                    )
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            Text(download.day)
                .font(.callout)
                .foregroundColor(currentDownloadID == download.id ? download.color : .black)
        }
    }
    
    // Get the max downloads to calculate the height of the bars dynamically
    func getMax() -> CGFloat {
        let max = downloads.max { first, second in
            return second.downloads > first.downloads
        }
        return max?.downloads ?? 0
    }
}

struct BarGraph_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()

        ContentView() .environmentObject(authViewModel)
    }
}


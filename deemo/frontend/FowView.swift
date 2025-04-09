import SwiftUI

struct Opportunity: Identifiable {
    var id = UUID()
    var name: String
    var category: String
    var location: String
    var date: String
    var description: String
}

class OpportunitiesViewModel: ObservableObject {
    @Published var opportunities: [Opportunity] = []
    @Published var searchText = ""
    @Published var selectedCategory: String? = nil

    init() {
        // Sample data
        opportunities = [
            Opportunity(name: "Beach Clean-up", category: "Environment", location: "Miami", date: "2025-03-22", description: "Help clean up the beach."),
            Opportunity(name: "Animal Shelter Help", category: "Animals", location: "New York", date: "2025-03-23", description: "Assist in animal shelter duties."),
            Opportunity(name: "Senior Care", category: "Aged People", location: "Los Angeles", date: "2025-03-25", description: "Provide care and companionship to seniors."),
            Opportunity(name: "Tutoring Students", category: "Education", location: "Chicago", date: "2025-03-26", description: "Offer tutoring services to students."),
            Opportunity(name: "Health Screening", category: "Health", location: "San Francisco", date: "2025-03-30", description: "Help with organizing health screening events.")
        ]
    }

    // Filter opportunities based on search text and selected category
    var filteredOpportunities: [Opportunity] {
        opportunities.filter { opportunity in
            (searchText.isEmpty || opportunity.name.lowercased().contains(searchText.lowercased())) &&
            (selectedCategory == nil || opportunity.category == selectedCategory)
        }
    }
}

struct FowView: View {
    @StateObject var viewModel = OpportunitiesViewModel()
    
    let categories = ["Environment", "Animals", "Aged People", "Education", "Health"]
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                TextField("Search for opportunities...", text: $viewModel.searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Category filter
                Picker("Category", selection: $viewModel.selectedCategory) {
                    Text("All Categories").tag(String?.none)
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(String?.some(category))
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                // List of opportunities
                List(viewModel.filteredOpportunities) { opportunity in
                    VStack(alignment: .leading) {
                        Text(opportunity.name)
                            .font(.headline)
                        Text(opportunity.category)
                            .font(.subheadline)
                        Text(opportunity.location)
                            .font(.subheadline)
                        Text("Date: \(opportunity.date)")
                            .font(.footnote)
                        Text(opportunity.description)
                            .font(.body)
                            .lineLimit(3)
                            .padding(.top, 5)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Find Opportunities")
        }
    }
}

struct FindOpportunitiesView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()
        FowView().environmentObject(authViewModel)
    }
}


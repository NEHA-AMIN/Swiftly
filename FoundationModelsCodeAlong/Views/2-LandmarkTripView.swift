import SwiftUI

struct LandmarkTripView: View {
    let landmark: Landmark
    
    @State private var itineraryGenerator: ItineraryGenerator?
    @State private var isKidMode: Bool = false
    @State private var isAdventureMode: Bool = true

    @State private var requestedItinerary: Bool = false
    
    var body: some View {
        ScrollView {
            if !requestedItinerary {
                VStack(alignment: .leading, spacing: 16) {
                    Text(landmark.name)
                        .padding(.top, 150)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(landmark.shortDescription)
                    
                    HStack(spacing: 16) {
                        Toggle(isOn: $isKidMode) {
                            Text("Kid Mode")
                                .fontWeight(.semibold)
                        }
                        .toggleStyle(.switch)
                        .onChange(of: isKidMode) { newValue in
                            if newValue { isAdventureMode = false }
                            else if !isAdventureMode { isAdventureMode = true }
                        }

                        Toggle(isOn: $isAdventureMode) {
                            Text("Adventure Mode")
                                .fontWeight(.semibold)
                        }
                        .toggleStyle(.switch)
                        .onChange(of: isAdventureMode) { newValue in
                            if newValue { isKidMode = false }
                            else if !isKidMode { isKidMode = true }
                        }
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            else if let itinerary = itineraryGenerator?.itinerary {
                ItineraryView(landmark: landmark, itinerary: itinerary).padding()
            }

        }
        .scrollDisabled(!requestedItinerary)
        .safeAreaInset(edge: .bottom) {
            ItineraryButton {
                requestedItinerary = true
                itineraryGenerator?.mode = isKidMode ? .kid : .adventure
                await itineraryGenerator?.generateItinerary()
            }

        }
        .task {
            let generator = ItineraryGenerator(landmark: landmark, mode: isKidMode ? .kid : .adventure)
            self.itineraryGenerator = generator
            generator.prewarmModel()
        }
        .headerStyle(landmark: landmark)
    }
    
}

//
//  ContentView.swift
//  SleepTracker
//
//  Created by Peter Eysermans on 17/07/2020.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @ObservedObject var viewModel : SleepModel
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            Text("Last night you slept: ")
            // show the text from the SleepModel in the UI
            Text(viewModel.mainText)
                .padding()
                // when the text appears call the SleepModel to fetch the necessary data
                .onAppear {
                    viewModel.retrieveSleep()
                }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.white, .blue]), startPoint: .top, endPoint: .bottom))
        // stretch the gradient from top to bottom, ignoring the safe area
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        

    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView(viewModel: SleepModel())
    }
}

class SleepModel : ObservableObject {
    @Published var mainText : String = "Getting your sleep time from yesterday"
    
    let sleepRetrieval = SleepRetrieval()
    
    func retrieveSleep() {
        sleepRetrieval.retrieveSleepWithAuth() { result -> Void in
            DispatchQueue.main.async {
                self.mainText = result
            }
        }
    }
}

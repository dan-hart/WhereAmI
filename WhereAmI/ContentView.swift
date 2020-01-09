//
//
//  ContentView
//  WhereAmI
//
//  Created by Dan Hart on 1/9/20.
//


import SwiftUI

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager()
    
    var cityName: String {
        return locationManager.placemark?.locality ?? "Unknown"
    }
    
    var body: some View {
        Text(cityName)
            .font(.largeTitle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

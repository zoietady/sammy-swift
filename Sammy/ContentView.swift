//
//  ContentView.swift
//  Sammy
//
//  Created by Zoie Tad-y on 6/29/20.
//  Copyright © 2020 Zoie Tad-y. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUpTime = defaultWakeUpTime
    @State private var hoursOfSleep = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView{
            ZStack {
                LinearGradient(gradient: Gradient(colors:[Color(red: 105 / 255, green: 207 / 255, blue: 231 / 255), Color(red: 32 / 255, green: 142 / 255, blue: 171 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                
                VStack{
                    Text("What time do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please Enter a time",
                               selection: $wakeUpTime,
                               displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    
                    Text("Desired Amount of Sleep:")
                        .font(.headline)
                        .padding(.bottom)
                    
                    Stepper(value: $hoursOfSleep, in: 4...12, step: 0.25){
                        Text("\(hoursOfSleep, specifier: "%g") hours")
                        .font(.system(size: 22))
                    }.padding(.bottom)
                    
                    
                    Text("Daily Coffee Intake:")
                        .font(.headline)
                        .padding(.bottom)
                    
                    Stepper(value: $coffeeAmount, in: 1...20){
                        if coffeeAmount == 1{
                            Text("1 cup")
                            .font(.system(size: 22))
                        } else{
                            Text("\(coffeeAmount) cups")
                            .font(.system(size: 22))
                        }
                    }.padding(.bottom)
                    
                    Text("Your Ideal Bedtime is:")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    Text("\(alertMessage)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom)
                        .padding(.top, 40)
                    Spacer()
                }
                .padding([.leading, .trailing], 60)
                .padding(.top, 30)
                .navigationBarTitle("SAMMY")
                .navigationBarItems(trailing:
                    Button(action: calculateBedtime){
                        Text("Calculate")
                    }
                )
                    .alert(isPresented: $showingAlert){
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
    
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedtime(){
        let model = SC()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute =  (components.minute ?? 0) * 60
        
        do{
            let prediction = try
                model.prediction(wake: Double (hour+minute), estimatedSleep: hoursOfSleep, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUpTime - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is"
            
        } catch{
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem with calculating your bedtime."
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Filippo on 26/12/23.
//

import SwiftUI

struct ContentView: View {
 @State private var order = Order()
 
 var body: some View {
	NavigationStack {
	 Form {
		Section {
		 Picker("Select your cake type", selection: $order.type) {
			ForEach(Order.types.indices, id: \.self) {
			 Text(Order.types[$0])
			}
		 }
		 
		 Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
		}
		Section {
		 Toggle("Any special requests?", isOn: $order.specialRequestEnabled)
		 
		 if order.specialRequestEnabled {
			Toggle("Add extra frosting", isOn: $order.extraFrosting)
			
			Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
		 }
		}
		Section {
		 NavigationLink("Delivery details") {
			AddressView(order: order)
		 }
		}
	 }
	 
	 .navigationTitle("Cupcake Corner")
	}
 }
}

@Observable
class Address: Codable {
 var name: String = ""
 var streetAddress: String = ""
 var city: String = ""
 var zip: String = ""
 var hasValidAddress: Bool {
	if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
	 return false
	}
	
	return true
 }
}

@Observable
class Order: Codable {
 
 enum CodingKeys: String, CodingKey {
	case _type = "type"
	case _quantity = "quantity"
	case _specialRequestEnabled = "specialRequestEnabled"
	case _extraFrosting = "extraFrosting"
	case _addSprinkles = "addSprinkles"
	case _address = "address"
	
	enum Address: String, CodingKey {
	 case _name = "name"
	 case _streetAddress = "streetAddress"
	 case _zip = "zip"
	 case _city = "city"
	}
	
 }
 
 var id = UUID()
 static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
 
 var type = 0
 var typeSelected : String {
	let available = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
	let choose = available[type]
	return choose
 }
 var quantity = 3
 
 var specialRequestEnabled = false {
	didSet {
	 if specialRequestEnabled == false {
		extraFrosting = false
		addSprinkles = false
	 }
	}
 }
 var extraFrosting = false
 var addSprinkles = false
 var address = Address()
 
 
 var cost: Double {
	var cost = Double(quantity) * 2
	cost += (Double(type) / 2)
	if extraFrosting {
	 cost += Double(quantity)
	}
	if addSprinkles {
	 cost += Double(quantity) / 2
	}
	
	return cost
 }
 
}

#Preview {
    ContentView()
}

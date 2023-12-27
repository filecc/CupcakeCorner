//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Filippo on 26/12/23.
//

import SwiftUI

struct AddressView: View {
 @Bindable var order: Order
 
 var body: some View {
	
	 Form {
		Section {
		 TextField("Name", text: $order.address.name)
		 TextField("Street Address", text: $order.address.streetAddress)
		 TextField("City", text: $order.address.city)
		 TextField("Zip", text: $order.address.zip)
		}
		Section {
		 NavigationLink("Check out") {
			CheckoutView(order: order)
		 }.disabled(!order.address.hasValidAddress).foregroundStyle(.blue)
		}
		
		
	 }.navigationTitle("Delivery details")
		.navigationBarTitleDisplayMode(.inline)
	
	
 }
}

#Preview {
 AddressView(order: Order())
}

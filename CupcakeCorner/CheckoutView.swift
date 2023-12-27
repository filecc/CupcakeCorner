//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Filippo on 26/12/23.
//

import SwiftUI

struct CheckoutView: View {
 var order: Order
 @State private var isLoading : Bool = false
 @State private var confirmationMessage = ""
 @State private var showingConfirmation = false
 
    var body: some View {
		 ScrollView {
			VStack {
			 AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
				image
				 .resizable()
				 .scaledToFit()
			 } placeholder: {
				ProgressView()
			 }
			 .frame(height: 233)
			 
			 Text("Your total is \(order.cost, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
				.font(.title)
			 
			 Button(isLoading ? "Loading..." : "Place Order") {
				Task {
				 await placeOrder()
				}
			 }
				.padding()
			}.alert("Thank you!", isPresented: $showingConfirmation) {
			 Button("OK") { }
			} message: {
			 Text(confirmationMessage)
			}
		 }
		 .navigationTitle("Check out")
		 .navigationBarTitleDisplayMode(.inline)
		 .scrollBounceBehavior(.basedOnSize)
    }
 func placeOrder() async {
	isLoading = true
	guard let encoded = try? JSONEncoder().encode(order) else {
	 print("Failed to encode order")
	 return
	}
	let url = URL(string: "https://reqres.in/api/cupcakes")!
	var request = URLRequest(url: url)
	request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	request.httpMethod = "POST"
	do {
	 let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
	 let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
	 confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
	 showingConfirmation = true
	 isLoading = false
	} catch {
	 print("Checkout failed: \(error.localizedDescription)")
	 isLoading = false
	}
	
 }
 
}

#Preview {
 CheckoutView(order: Order())
}

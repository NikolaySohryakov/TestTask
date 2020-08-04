//
//  PersonDetails.swift
//  TestTask
//
//  Created by Nikolay Sohryakov on 03.08.2020.
//  Copyright © 2020 Storytelling Software. All rights reserved.
//

import SwiftUI

struct PersonDetails: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: PersonDetailsViewModel

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else {
                List {
                    DetailRow(title: "First name", value: viewModel.person.firstName ?? " - ")
                    DetailRow(title: "Last name", value: viewModel.person.lastName ?? "-")
                    DetailRow(title: "Age", value: viewModel.person.age == nil ? "-" : String(viewModel.person.age!))
                    DetailRow(title: "Gender", value: viewModel.person.gender ?? "-")
                    DetailRow(title: "Country", value: viewModel.person.country ?? "-")
                }
            }
        }
        .navigationBarTitle("Person details")
        .onAppear {
            UITableView.appearance().tableFooterView = UIView()
            self.viewModel.loadPersonDetails()
        }
        .alert(isPresented: self.$viewModel.showError) {
            Alert(title: Text(self.viewModel.errorMessage), dismissButton: Alert.Button.default(Text("OK")) { 
                self.mode.wrappedValue.dismiss()
            })
        }
    }
}

fileprivate struct DetailRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
    }
}

struct PersonDetails_Previews: PreviewProvider {
    static var previews: some View {
        let repository = FakePeopleRepository()
        let person = Person(
            id: "id1",
            firstName: "John",
            lastName: "Doe",
            age: 30,
            gender: "Male",
            country: "United States")
        
        return Group {
            DetailRow(title: "First Name", value: "John")
                .previewLayout(.sizeThatFits)
            
            PersonDetails(viewModel: PersonDetailsViewModel(repository: repository, person: person))
        }
    }
}

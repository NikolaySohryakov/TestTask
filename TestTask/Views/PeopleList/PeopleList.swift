//
//  PeopleList.swift
//  TestTask
//
//  Created by Nikolay Sohryakov on 03.08.2020.
//  Copyright © 2020 Storytelling Software. All rights reserved.
//

import SwiftUI

struct PeopleList: View {
    @ObservedObject var viewModel: PeopleListViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    LoadingView()
                }
                else {
                    List {
                        ForEach(self.viewModel.allPeople) { person in
                            NavigationLink(destination: self.personDetailsView(for: person)) {
                                Text(person.id)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("IDs")
        }
        .onAppear {
            self.viewModel.loadPeople()
        }
    }
    
    private func personDetailsView(for person: Person) -> some View {
        let viewModel = PersonDetailsViewModel(repository: self.viewModel.repository, person: person)
        
        return PersonDetails(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let repository = FakePeopleRepository()
        
        return PeopleList(viewModel: PeopleListViewModel(repository: repository))
    }
}

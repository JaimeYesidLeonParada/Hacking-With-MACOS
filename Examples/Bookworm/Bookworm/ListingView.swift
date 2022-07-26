//
//  ListingView.swift
//  Bookworm
//
//  Created by Jaime Yesid Leon Parada on 4/07/22.
//

import SwiftUI

struct ListingView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.id)]) var reviews: FetchedResults<Review>
    @AppStorage("id") var id = 1
    @State private var selectedReview: Review?
    
    var body: some View {
        List(reviews) { review in
            NavigationLink(tag: review, selection: $selectedReview) {
                DetailView(review: review)
            } label: {
                Text(review.reviewTitle)
            }
        }
        .onDeleteCommand(perform: deleteSelected)
        .contextMenu {
            Button("Delete", role: .destructive, action: deleteSelected)
        }
        .toolbar{
            Button(action: addReview) {
                Label("Add Review", systemImage: "plus")
            }
            Button(action: deleteSelected) {
                Label("Delete", systemImage: "trash")
            }
            .disabled(selectedReview == nil)
        }
    }
    
    func addReview() {
        let review = Review(context: managedObjectContext)
        review.id = Int16(id)
        review.title = "Enter the title"
        review.author = "Enter the author"
        review.rating = 3
        
        id += 1
        
        dataController.save()
        selectedReview = review
    }
    
    func deleteSelected() {
        guard let selected = selectedReview else { return }
        guard let selectedIndex = reviews.firstIndex(of: selected) else { return }
        
        managedObjectContext.delete(selected)
        dataController.save()
        
        if selectedIndex < reviews.count {
            selectedReview = reviews[selectedIndex]
        } else {
            let previousIndex = selectedIndex - 1
            
            if previousIndex >= 0 {
                selectedReview = reviews[previousIndex]
            }
        }
    }
}

struct ListingView_Previews: PreviewProvider {
    static var previews: some View {
        ListingView()
    }
}

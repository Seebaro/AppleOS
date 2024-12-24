//
//  FileManagerView.swift
//  Sibaro
//
//  Created by AminRa on 9/4/1403 AP.
//

import SwiftUI

struct FileManagerView: View {
    
    @StateObject var viewModel: ViewModel
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var layout: [GridItem] {
        if horizontalSizeClass == .compact {
            [GridItem(.flexible(), alignment: .top)]
        } else {
            [GridItem(.adaptive(minimum: 360), alignment: .top)]
        }
    }
#else
    var layout = [GridItem(.adaptive(minimum: 360), alignment: .top)]
#endif
    
    init() {
        self._viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    @State private var showAlert = false
    @State private var showingDocumentPicker = false
    @State private var statusMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.files.isEmpty {
                    Text("The are no files yet\nuse **+** to add files")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16, design: .rounded))
                } else {
                    List {
                        ForEach(viewModel.files) { ipa in
                            NavigationLink(
                                destination: FileDetailView(
                                    ipa: ipa,
                                    ipaInfo: viewModel.getIPAInformation(ipa)
                                )
                            ) {
                                FileListItem(ipaFile: ipa)
                                    .swipeActions(allowsFullSwipe: false) {
                                        Button(role: .destructive) {
                                            viewModel.deleteIPA(ipa)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        
                                        Button {
                                            viewModel.signIPA(ipa)
                                        } label: {
                                            Label("Sign", systemImage: "pencil")
                                        }
                                        
                                        Button {
                                            viewModel.installIPA(ipa)
                                        } label: {
                                            Label("Install", systemImage: "arrow.down.circle")
                                        }
                                        .tint(.green)
                                    }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Files")
            .sheet(isPresented: $showingDocumentPicker) {
                DocumentPicker { result in
                    switch result {
                    case .success(let url):
                        viewModel.saveFileToCurrentDirectory(fileURL: url)
                    case .failure(let error):
                        statusMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }.alert(statusMessage ?? "", isPresented: $showAlert) {
                Button("Dismiss", role: .cancel, action: {
                    showAlert.toggle()
                    statusMessage = nil
                })
            }.onReceive(viewModel.alertSubject.eraseToAnyPublisher()) { message in
                statusMessage = message
                showAlert.toggle()
            }
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showingDocumentPicker = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .bold))
                        .padding()
                }
            }
        }
    }
}

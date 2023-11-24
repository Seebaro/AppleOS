//
//  UpdateService.swift
//  Sibaro
//
//  Created by Emran on 11/4/23.
//

import Foundation
import Combine

protocol UpdateServicable: BaseService {
    var updateSubject: PassthroughSubject<Bool, Never> { get }
    func needsUpdate(force: Bool, link: String?)
    func update()
}

class UpdateService: BaseService, UpdateServicable {
    
    @Injected(\.openURL) var openURL
    private var updateLink: URL?
    
    override init() {
        super.init()
        $updateState.filter { $0 != .none }.map { $0 == .force }.removeDuplicates().subscribe(updateSubject).store(in: &cancelBag)
    }
    
    let updateSubject: PassthroughSubject<Bool, Never> = PassthroughSubject()
    @Published private var updateState: UpdateState = .none
    
    func update() {
        guard let updateLink else { return }
        let _ = openURL(updateLink)
    }
    
    func needsUpdate(force: Bool, link: String?) {
        if let link, let link = URL(string: link) {
            updateLink = link
        }
        DispatchQueue.main.async { [unowned self] in
            updateState = force ? .force : .optional
        }
    }
}

enum UpdateState {
    case force
    case optional
    case none
}

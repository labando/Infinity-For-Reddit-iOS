//
//  UITableViewList.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-22.
//

import UIKit
import SwiftUI

struct UITableViewList<Item>: UIViewRepresentable {
    let items: [Item]
    let viewForItem: (Item) -> AnyView
    let onItemAppear: ((Int, Item) -> Void)?
    
    var scrollFromBottom: Bool = false
    var shouldScrollToBottom: Bool = false
    @Binding var scrollToBottomTrigger: Bool
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        if scrollFromBottom {
            tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
            tableView.showsVerticalScrollIndicator = false
        }
        
        tableView.register(HostingCell.self, forCellReuseIdentifier: "HostingCell")
        
        return tableView
    }

    func updateUIView(_ uiView: UITableView, context: Context) {
        context.coordinator.items = items
        context.coordinator.onItemAppear = onItemAppear
        uiView.reloadData()
        
        if shouldScrollToBottom || scrollToBottomTrigger {
            DispatchQueue.main.async {
                if uiView.numberOfSections > 0 {
                    let lastSection = uiView.numberOfSections - 1
                    let lastRow = uiView.numberOfRows(inSection: lastSection) - 1
                    if lastRow >= 0 {
                        // Declare indexPath here
                        let indexPath = IndexPath(row: lastRow, section: lastSection)
                        // Ensure we scroll to the actual bottom if it's a bottom-up list
                        // For a standard list, it's just the end.
                        uiView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
                scrollToBottomTrigger = false
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(items: items, viewForItem: viewForItem, onItemAppear: onItemAppear, scrollFromBottom: scrollFromBottom)
    }

    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        var items: [Item]
        let viewForItem: (Item) -> AnyView
        var onItemAppear: ((Int, Item) -> Void)?
        let scrollFromBottom: Bool

        init(items: [Item],
             viewForItem: @escaping (Item) -> AnyView,
             onItemAppear: ((Int, Item) -> Void)?,
             scrollFromBottom: Bool
        ) {
            self.items = items
            self.viewForItem = viewForItem
            self.onItemAppear = onItemAppear
            self.scrollFromBottom = scrollFromBottom
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            items.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HostingCell", for: indexPath) as! HostingCell
            
            if scrollFromBottom {
                cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            } else {
                // Ensure no leftover transform if this cell was previously used for a bottom-up list
                cell.contentView.transform = .identity
            }
            
            let swiftUIView = viewForItem(items[indexPath.row])
            cell.set(rootView: swiftUIView)

            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            
            return cell
        }

        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let index = indexPath.row
            guard index < items.count else { return }
            onItemAppear?(index, items[index])
        }
    }
}

class HostingCell: UITableViewCell {
    private var hostingController: UIHostingController<AnyView>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none
    }

    func set(rootView: AnyView) {
        if hostingController == nil {
            hostingController = UIHostingController(rootView: rootView)
            guard let hcView = hostingController?.view else { return }
            
            hcView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(hcView)
            
            NSLayoutConstraint.activate([
                hcView.topAnchor.constraint(equalTo: contentView.topAnchor),
                hcView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                hcView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hcView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
        } else {
            hostingController?.rootView = rootView
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        hostingController?.view.frame = contentView.bounds
    }
}


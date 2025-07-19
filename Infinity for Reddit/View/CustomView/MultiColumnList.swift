////
////  MultiColumnList.swift
////  Infinity for Reddit
////
////  Created by Docile Alligator on 2025-06-22.
////
//
//import UIKit
//import SwiftUI
//
//struct MultiColumnList<Item>: UIViewRepresentable {
//    var items: [Item]
//    var numberOfColumns: Int
//    var viewForItem: (Item) -> AnyView
//    var onItemAppear: ((Int, Item) -> Void)?
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> UICollectionView {
//        let layout = StaggeredGridLayout(columns: numberOfColumns)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(HostingCollectionViewCell.self, forCellWithReuseIdentifier: "HostingCell")
//        collectionView.dataSource = context.coordinator
//        collectionView.delegate = context.coordinator
//        collectionView.backgroundColor = .clear
//        return collectionView
//    }
//
//    func updateUIView(_ uiView: UICollectionView, context: Context) {
//        context.coordinator.parent = self
//        uiView.reloadData()
//    }
//
//    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//        var parent: MultiColumnList
//
//        init(_ parent: MultiColumnList) {
//            self.parent = parent
//        }
//
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            parent.items.count
//        }
//
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let item = parent.items[indexPath.item]
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HostingCell", for: indexPath) as! HostingCollectionViewCell
//            cell.host(view: parent.viewForItem(item))
//            return cell
//        }
//
//        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            let index = indexPath.item
//            guard index < parent.items.count else { return }
//            parent.onItemAppear?(index, parent.items[index])
//        }
//    }
//}
//
//class HostingCollectionViewCell: UICollectionViewCell {
//    private var hostingController: UIHostingController<AnyView>?
//
//    func host(view: AnyView) {
//        if let hostingController = hostingController {
//            hostingController.rootView = view
//            hostingController.view.invalidateIntrinsicContentSize()
//        } else {
//            let controller = UIHostingController(rootView: view)
//            controller.view.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview(controller.view)
//            NSLayoutConstraint.activate([
//                controller.view.topAnchor.constraint(equalTo: contentView.topAnchor),
//                controller.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//                controller.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//                controller.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            ])
//            hostingController = controller
//        }
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        hostingController?.rootView = AnyView(EmptyView())
//    }
//}
//
//class StaggeredGridLayout: UICollectionViewLayout {
//    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
//    private var contentHeight: CGFloat = 0
//    private var contentWidth: CGFloat {
//        collectionView?.bounds.width ?? 0
//    }
//
//    let columns: Int
//    let spacing: CGFloat = 8
//    var cache: [UICollectionViewLayoutAttributes] = []
//
//    init(columns: Int) {
//        self.columns = columns
//        super.init()
//    }
//
//    required init?(coder: NSCoder) { fatalError() }
//
//    override func prepare() {
//        guard let collectionView = collectionView else { return }
//
//        cache.removeAll()
//        contentHeight = 0
//
//        let columnWidth = (contentWidth - spacing * CGFloat(columns - 1)) / CGFloat(columns)
//        var xOffset: [CGFloat] = (0..<columns).map { CGFloat($0) * (columnWidth + spacing) }
//        var yOffset: [CGFloat] = .init(repeating: 0, count: columns)
//
//        for item in 0..<collectionView.numberOfItems(inSection: 0) {
//            let indexPath = IndexPath(item: item, section: 0)
//            let column = yOffset.firstIndex(of: yOffset.min() ?? 0) ?? 0
//            let height: CGFloat = 200 + CGFloat(item % 5) * 20  // placeholder height
//            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
//            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//            attr.frame = frame
//            cache.append(attr)
//            yOffset[column] += height + spacing
//            contentHeight = max(contentHeight, yOffset[column])
//        }
//    }
//
//    override var collectionViewContentSize: CGSize {
//        CGSize(width: contentWidth, height: contentHeight)
//    }
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        cache.filter { $0.frame.intersects(rect) }
//    }
//
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        cache.first { $0.indexPath == indexPath }
//    }
//}

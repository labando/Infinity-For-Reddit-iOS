////
////  MultiColumnListTest.swift
////  Infinity for Reddit
////
////  Created by Docile Alligator on 2025-07-19.
////
//
//import UIKit
//import SwiftUI
//
//// --- MultiColumnListTest ---
//// No significant functional changes here, just ensuring the Item type is generic
//// and we pass the calculated columnWidth to the viewForItem closure.
//struct MultiColumnListTest<Item>: UIViewRepresentable where Item: Identifiable { // Item must be Identifiable for efficient updates if needed
//    var items: [Item]
//    var numberOfColumns: Int
//    var viewForItem: (Item, CGFloat) -> AnyView // Pass Item and the calculated columnWidth
//    var onItemAppear: ((Int, Item) -> Void)?
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> UICollectionView {
//        let layout = StaggeredGridLayout(columns: numberOfColumns, delegate: context.coordinator)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(HostingCollectionViewCell.self, forCellWithReuseIdentifier: "HostingCell")
//        collectionView.dataSource = context.coordinator
//        collectionView.delegate = context.coordinator
//        collectionView.backgroundColor = .clear
//        // Important: Set allowsSelection to false if cells are just display
//        collectionView.allowsSelection = false
//        // Add content inset adjustment behavior to avoid automatic insets
//        collectionView.contentInsetAdjustmentBehavior = .always // Or .never if you manage all insets manually
//        return collectionView
//    }
//
//    func updateUIView(_ uiView: UICollectionView, context: Context) {
//        context.coordinator.parent = self
//        // Invalidate layout when data changes to ensure prepare() runs again
//        if let layout = uiView.collectionViewLayout as? StaggeredGridLayout {
//            layout.invalidateLayout()
//        }
//        uiView.reloadData()
//    }
//
//    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, StaggeredGridLayoutDelegate {
//        var parent: MultiColumnListTest
//        // Cache to store calculated heights. Essential for performance and stability.
//        var itemHeightCache: [Item.ID: CGFloat] = [:] // Use Item.ID for caching
//
//        init(_ parent: MultiColumnListTest) {
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
//            
//            // Calculate columnWidth *exactly* as the layout does, so ItemView gets the correct dimension.
//            guard let layout = collectionView.collectionViewLayout as? StaggeredGridLayout else {
//                fatalError("CollectionView layout is not StaggeredGridLayout")
//            }
//            let availableWidth = collectionView.bounds.width - layout.sectionInsets.left - layout.sectionInsets.right
//            let columnWidth = (availableWidth - layout.spacing * CGFloat(layout.columns - 1)) / CGFloat(layout.columns)
//            let safeColumnWidth = max(0, columnWidth) // Ensure non-negative width
//            
//            // Host the SwiftUI view, passing the calculated safeColumnWidth
//            cell.host(view: parent.viewForItem(item, safeColumnWidth))
//            
//            // Optional: Set a background color for debugging cell frames
//            cell.contentView.backgroundColor = .clear // Or a color like .red.opacity(0.1) for debugging
//            
//            return cell
//        }
//
//        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            let index = indexPath.item
//            guard index < parent.items.count else { return }
//            parent.onItemAppear?(index, parent.items[index])
//        }
//        
//        // MARK: - StaggeredGridLayoutDelegate
//        // This is where the StaggeredGridLayout asks for an item's height.
//        // We'll calculate it by asking the SwiftUI view directly or using a cache.
//        func staggeredGridLayout(_ layout: StaggeredGridLayout, heightForItemAtIndexPath indexPath: IndexPath, columnWidth: CGFloat) -> CGFloat {
//            guard indexPath.item < parent.items.count else { return 0 }
//            let item = parent.items[indexPath.item]
//
//            // Try to get height from cache first
//            if let cachedHeight = itemHeightCache[item.id] {
//                return cachedHeight
//            }
//            
//            // If not cached, we need to measure the SwiftUI view.
//            // Create a temporary hosting controller to measure the SwiftUI view.
//            // This is a common pattern for UICollectionView self-sizing, though can be costly if overused.
//            // For a layout that always calculates upfront, this is the way.
//            let dummyHostingController = UIHostingController(rootView: parent.viewForItem(item, columnWidth))
//            dummyHostingController.view.translatesAutoresizingMaskIntoConstraints = false
//            
//            // It's crucial to give the dummy view a parent to correctly calculate its size
//            // We can add it to a temporary, off-screen view, or simply rely on systemLayoutSizeFitting
//            // to do its job without adding to a hierarchy if the SwiftUI view is simple enough.
//            // For complex views, adding it to a temp hierarchy helps. Let's try without it first.
//
//            let targetSize = CGSize(width: columnWidth, height: UIView.layoutFittingExpandedSize.height)
//            let fittingSize = dummyHostingController.view.systemLayoutSizeFitting(
//                targetSize,
//                withHorizontalFittingPriority: .required,
//                verticalFittingPriority: .fittingSizeLevel
//            )
//            
//            let calculatedHeight = fittingSize.height
//            
//            // Cache the calculated height for this item
//            itemHeightCache[item.id] = calculatedHeight
//            
//            return calculatedHeight
//        }
//    }
//}
//
//// --- HostingCollectionViewCell ---
//// This cell's job is simply to host the SwiftUI view and pass its sizing information.
//class HostingCollectionViewCell: UICollectionViewCell {
//    private var hostingController: UIHostingController<AnyView>?
//
//    func host(view: AnyView) {
//        // If no hosting controller exists, create and add it
//        if hostingController == nil {
//            let controller = UIHostingController(rootView: view)
//            controller.view.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview(controller.view)
//            NSLayoutConstraint.activate([
//                controller.view.topAnchor.constraint(equalTo: contentView.topAnchor),
//                controller.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//                controller.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//                controller.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            ])
//            self.hostingController = controller
//        } else {
//            // If it exists, just update the root view
//            hostingController?.rootView = view
//        }
//        
//        // Ensure SwiftUI view is asked to lay itself out immediately so its intrinsicContentSize is accurate
//        hostingController?.view.setNeedsLayout()
//        hostingController?.view.layoutIfNeeded()
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        // Crucial for performance and preventing ghosting/old content
//        hostingController?.view.removeFromSuperview()
//        hostingController = nil
//    }
//    
//    // This method is called by UICollectionViewLayout to get the cell's preferred size.
//    // It's vital that this returns an accurate height for the given width.
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
//        
//        guard let hostedView = hostingController?.view else { return attributes }
//
//        // Ask the hosted SwiftUI view for its ideal size given the width provided by the layout.
//        let targetSize = CGSize(width: layoutAttributes.size.width,
//                                height: UIView.layoutFittingExpandedSize.height) // Allow height to expand
//        
//        // This is the core call to SwiftUI's layout engine through UIKit
//        let fittingSize = hostedView.systemLayoutSizeFitting(
//            targetSize,
//            withHorizontalFittingPriority: .required, // Must constrain horizontally
//            verticalFittingPriority: .fittingSizeLevel // Let it grow vertically
//        )
//        
//        // Update the attributes with the measured height
//        attributes.frame.size.height = fittingSize.height
//        
//        return attributes
//    }
//}
//
//// --- StaggeredGridLayout ---
//// Focused on ensuring accurate columnWidth and xOffset.
//protocol StaggeredGridLayoutDelegate: AnyObject {
//    func staggeredGridLayout(_ layout: StaggeredGridLayout, heightForItemAtIndexPath indexPath: IndexPath, columnWidth: CGFloat) -> CGFloat
//}
//
//class StaggeredGridLayout: UICollectionViewLayout {
//    private var layoutAttributesCache: [UICollectionViewLayoutAttributes] = []
//    private var contentHeight: CGFloat = 0
//    private var contentWidth: CGFloat {
//        // Use the collection view's current bounds width for calculations
//        collectionView?.bounds.width ?? 0
//    }
//
//    let columns: Int
//    let spacing: CGFloat = 8 // Inter-item spacing
//    let sectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) // Padding for the whole grid
//    
//    weak var delegate: StaggeredGridLayoutDelegate?
//
//    init(columns: Int, delegate: StaggeredGridLayoutDelegate? = nil) {
//        self.columns = columns
//        self.delegate = delegate
//        super.init()
//    }
//
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//
//    override func prepare() {
//        guard let collectionView = collectionView, let delegate = delegate else { return }
//
//        // Clear cache and recalculate if:
//        // 1. Cache is empty (first load)
//        // 2. Number of items changed
//        // 3. The layout was invalidated (e.g., due to bounds change like rotation)
//        let numberOfItems = collectionView.numberOfItems(inSection: 0)
//        if layoutAttributesCache.isEmpty || layoutAttributesCache.count != numberOfItems {
//            layoutAttributesCache.removeAll()
//            contentHeight = 0
//
//            // Calculate the actual usable width for items
//            let availableWidth = contentWidth - sectionInsets.left - sectionInsets.right
//            
//            // Calculate individual column width.
//            // This formula ensures `columns` items fit within `availableWidth`
//            // with `columns - 1` spaces between them.
//            let columnWidth = (availableWidth - spacing * CGFloat(columns - 1)) / CGFloat(columns)
//            let safeColumnWidth = max(0, columnWidth) // Prevent negative widths
//
//            // Pre-calculate x positions for each column
//            var xOffset: [CGFloat] = []
//            for i in 0..<columns {
//                xOffset.append(sectionInsets.left + CGFloat(i) * (safeColumnWidth + spacing))
//            }
//            
//            // Initialize y positions for each column, starting with the top inset
//            var yOffset: [CGFloat] = .init(repeating: sectionInsets.top, count: columns)
//
//            for itemIndex in 0..<numberOfItems {
//                let indexPath = IndexPath(item: itemIndex, section: 0)
//                // Find the column with the minimum height to place the next item
//                let column = yOffset.firstIndex(of: yOffset.min() ?? 0) ?? 0
//                
//                // Ask the delegate for the item's height. This will trigger the SwiftUI view measurement.
//                let itemHeight = delegate.staggeredGridLayout(self, heightForItemAtIndexPath: indexPath, columnWidth: safeColumnWidth)
//                
//                // Create the frame for the current item
//                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: safeColumnWidth, height: itemHeight)
//                
//                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//                attr.frame = frame
//                layoutAttributesCache.append(attr)
//                
//                // Update the yOffset for the chosen column
//                yOffset[column] += itemHeight + spacing
//                
//                // Update the overall content height
//                contentHeight = max(contentHeight, yOffset[column])
//            }
//            
//            // Add bottom inset to the final content height
//            contentHeight += sectionInsets.bottom
//        }
//    }
//
//    override var collectionViewContentSize: CGSize {
//        CGSize(width: contentWidth, height: contentHeight)
//    }
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        // Filter and return only the attributes for items visible in the current rect
//        return layoutAttributesCache.filter { $0.frame.intersects(rect) }
//    }
//
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        // Return the specific attributes for a given indexPath
//        guard indexPath.item < layoutAttributesCache.count else { return nil }
//        return layoutAttributesCache[indexPath.item]
//    }
//    
//    // Crucial for handling device rotations or changes in collection view size
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        // Invalidate the layout if the collection view's width changes
//        guard let collectionView = collectionView else { return false }
//        return newBounds.width != collectionView.bounds.width
//    }
//}


//import UIKit
//import SwiftUI
//
//class HostingCollectionViewCell: UICollectionViewCell {
//    private var hostingController: UIHostingController<AnyView>?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.backgroundColor = .clear // Ensure the content view itself is transparent
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    /// Hosts a SwiftUI view within the cell, updating it if already present.
//    /// - Parameter view: The SwiftUI `AnyView` to host.
//    func host(view: AnyView) {
//        // If a hosting controller doesn't exist, create and embed it.
//        if hostingController == nil {
//            hostingController = UIHostingController(rootView: view)
//            guard let hcView = hostingController?.view else { return }
//
//            // Important: Disable translatesAutoresizingMaskIntoConstraints so we can use Auto Layout
//            hcView.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview(hcView)
//
//            // Pin the hostingController's view to the content view's edges
//            NSLayoutConstraint.activate([
//                hcView.topAnchor.constraint(equalTo: contentView.topAnchor),
//                hcView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//                hcView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//                hcView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
//            ])
//            print("HostingCollectionViewCell \(ObjectIdentifier(self)): Created new UIHostingController for view type \(type(of: view)).")
//        } else {
//            // If a hosting controller already exists, just update its `rootView`.
//            // SwiftUI will handle diffing and updating its hierarchy efficiently.
//            hostingController?.rootView = view
//            print("HostingCollectionViewCell \(ObjectIdentifier(self)): Updated existing UIHostingController's rootView to view type \(type(of: view)).")
//        }
//        
//        // CRITICAL: Force layout on the hosted view. This tells SwiftUI to re-evaluate its content
//        // based on the new frame that UICollectionView is giving to this cell.
//        // This is essential for SwiftUI views to correctly self-size within a UIKit container.
//        hostingController?.view.setNeedsLayout()
//        hostingController?.view.layoutIfNeeded()
//        print("HostingCollectionViewCell \(ObjectIdentifier(self)): Forced layoutIfNeeded on hosted view.")
//    }
//
//    /// Called when the cell is about to be reused by the collection view.
//    /// This is important for performance and preventing visual glitches (flickering old content).
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        // Reset hosted view to an empty state. This effectively "cleans" the cell
//        // before it's used to display new content.
//        hostingController?.rootView = AnyView(EmptyView())
//        print("HostingCollectionViewCell \(ObjectIdentifier(self)): prepareForReuse - Resetting hosted view.")
//    }
//    
//    /// This method is called by UICollectionViewLayout to determine the cell's preferred size.
//    /// While our `StaggeredGridLayout` directly asks its delegate for item heights, this method
//    /// is still part of the UIKit standard for cell sizing and can be used to ensure the cell
//    /// itself correctly wraps its content.
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        // ✅ Make sure layout is up-to-date
//            setNeedsLayout()
//            layoutIfNeeded()
//
//            guard let hcView = hostingController?.view else {
//                return layoutAttributes
//            }
//
//            // ✅ Force layout constraints so SwiftUI view gets correct width
//            let targetWidth = layoutAttributes.frame.width
//            let targetSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)
//
//            // ✅ Constrain the width manually (CRITICAL for SwiftUI to respect it!)
//            let widthConstraint = hcView.widthAnchor.constraint(equalToConstant: targetWidth)
//            widthConstraint.priority = .required
//            widthConstraint.isActive = true
//
//            // ✅ Force layout again with correct width constraint
//            hcView.setNeedsLayout()
//            hcView.layoutIfNeeded()
//
//            let fittingSize = hcView.systemLayoutSizeFitting(
//                targetSize,
//                withHorizontalFittingPriority: .required,
//                verticalFittingPriority: .fittingSizeLevel
//            )
//
//            widthConstraint.isActive = false // Clean up
//
//            layoutAttributes.frame.size = CGSize(width: targetWidth, height: fittingSize.height)
//
//            print("HostingCollectionViewCell \(ObjectIdentifier(self)): preferredLayoutAttributesFitting - measured size \(fittingSize) for width \(targetWidth).")
//
//            return layoutAttributes
//    }
//}
//
//// MARK: - 3. StaggeredGridLayout (Custom UICollectionViewLayout)
//
//protocol StaggeredGridLayoutDelegate: AnyObject {
//    /// Asks the delegate for the height of an item at a specific index path, given a column width.
//    /// This is where the SwiftUI view for that item will be measured to determine its height in the grid.
//    func staggeredGridLayout(_ layout: StaggeredGridLayout, heightForItemAtIndexPath indexPath: IndexPath, columnWidth: CGFloat) -> CGFloat
//    
//    func staggeredGridLayoutDidInvalidateLayoutDueToWidthChange(_ layout: StaggeredGridLayout)
//}
//
//class StaggeredGridLayout: UICollectionViewLayout {
//    
//    weak var delegate: StaggeredGridLayoutDelegate?
//    var columns: Int
//    var spacing: CGFloat
//    var sectionInsets: UIEdgeInsets
//
//    // Cache to store pre-calculated layout attributes for performance.
//    // Cleared when the layout needs to be recalculated (e.g., width change).
//    private var cache: [UICollectionViewLayoutAttributes] = []
//    // Array to track the current height of each column, used to determine where to place the next item.
//    private var columnHeights: [CGFloat] = []
//    // Tracks the content width of the collection view used in the last `prepare` call.
//    // Used to efficiently determine if a full recalculation is necessary.
//    private var currentLayoutContentWidth: CGFloat = 0
//
//    init(columns: Int, spacing: CGFloat = 8, sectionInsets: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8), delegate: StaggeredGridLayoutDelegate? = nil) {
//        self.columns = columns
//        self.spacing = spacing
//        self.sectionInsets = sectionInsets
//        self.delegate = delegate
//        super.init()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    /// Called by UICollectionView when the layout needs to be calculated or invalidated.
//    /// This is where all item frames are determined.
//    override func prepare() {
//        print("--- StaggeredGridLayout.prepare() called ---")
//        guard let collectionView = collectionView else {
//            print("StaggeredGridLayout.prepare(): collectionView is nil.")
//            return
//        }
//
//        let newContentWidth = collectionView.bounds.width - sectionInsets.left - sectionInsets.right
//        
//        // Only perform a full recalculation if the cache is empty, column heights are unset,
//        // or if the collection view's width has changed.
//        let shouldRecalculate = cache.isEmpty || columnHeights.isEmpty || newContentWidth != currentLayoutContentWidth
//
//        if !shouldRecalculate {
//            print("StaggeredGridLayout.prepare(): Cache valid, content width unchanged (\(newContentWidth)). Skipping full recalculation.")
//            return
//        }
//        
//        print("StaggeredGridLayout.prepare(): Performing full layout recalculation (width change or initial load).")
//        cache.removeAll() // Clear old layout attributes
//        columnHeights = Array(repeating: sectionInsets.top, count: columns) // Reset column heights to top inset
//        currentLayoutContentWidth = newContentWidth // Update the tracked width for future comparisons
//
//        // Calculate the effective width available for items, considering spacing between columns.
//        let availableWidthForItems = newContentWidth - (CGFloat(columns - 1) * spacing)
//        let columnWidth = max(0, availableWidthForItems / CGFloat(columns))
//        
//        print("StaggeredGridLayout.prepare(): Calculated columnWidth = \(columnWidth), newContentWidth = \(newContentWidth)")
//
//        // Iterate through all items in the first section (assuming single section for simplicity)
//        for item in 0..<collectionView.numberOfItems(inSection: 0) {
//            let indexPath = IndexPath(item: item, section: 0)
//
//            // Find the shortest column to place the next item, ensuring a balanced grid.
//            let shortestColumnIndex = columnHeights.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
//            
//            // Calculate the X and Y position for the item's frame.
//            let xOffset = sectionInsets.left + (columnWidth + spacing) * CGFloat(shortestColumnIndex)
//            let yOffset = columnHeights[shortestColumnIndex]
//
//            // Ask the delegate (our Coordinator) for the item's height. This is where SwiftUI
//            // view measurement happens, given the calculated column width.
//            let itemHeight = delegate?.staggeredGridLayout(self, heightForItemAtIndexPath: indexPath, columnWidth: columnWidth) ?? 0
//
//            // Create the frame for the item and its layout attributes.
//            let frame = CGRect(x: xOffset, y: yOffset, width: columnWidth, height: itemHeight)
//            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//            attributes.frame = frame
//            cache.append(attributes) // Store the attributes in the cache
//
//            // Update the height of the column where the item was just placed, adding spacing for the next item.
//            columnHeights[shortestColumnIndex] = yOffset + itemHeight + spacing
//        }
//        print("--- End StaggeredGridLayout.prepare() ---")
//    }
//
//    /// Returns the total scrollable size of the content within the collection view.
//    override var collectionViewContentSize: CGSize {
//        guard let collectionView = collectionView else { return .zero }
//        
//        let contentWidth = collectionView.bounds.width // The content width is typically the collection view's width
//        let contentHeight = (columnHeights.max() ?? 0) + sectionInsets.bottom // The height is determined by the tallest column plus bottom inset
//        
//        print("StaggeredGridLayout.collectionViewContentSize: calculated height = \(contentHeight) for width \(contentWidth).")
//        return CGSize(width: contentWidth, height: contentHeight)
//    }
//
//    /// Returns the layout attributes for items within a given rectangle (the visible content area).
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        // Filter the cached attributes to return only those that intersect the requested rect.
//        return cache.filter { $0.frame.intersects(rect) }
//    }
//
//    /// Returns layout attributes for a specific item at a given index path.
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard indexPath.item < cache.count else { return nil }
//        return cache[indexPath.item]
//    }
//
//    // MARK: - shouldInvalidateLayout(forBoundsChange:) - THIS IS THE METHOD YOU ASKED ABOUT
//    /// Determines if the layout needs to be re-calculated when the collection view's bounds change.
//    /// This is a critical method for responsiveness and performance.
//    ///
//    /// The quote "Overriding shouldInvalidateLayoutForBoundsChange:to return YES... will result in
//    /// invalidateLayout being called automatically whenever the collection view's bounds change
//    /// (including when its size changes and when the user scrolls its contents)" is important.
//    ///
//    /// For a staggered layout, we generally *only* need to invalidate (trigger a full `prepare()` recalculation)
//    /// if the **size (specifically the width)** of the collection view changes. Changes in scroll
//    /// position (bounds.origin) do NOT require re-calculating item positions, as items simply move
//    /// with the scroll.
//    ///
//    /// Therefore, this implementation prioritizes performance by only invalidating when a true
//    /// layout-affecting change (width) occurs.
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        guard let collectionView = collectionView else { return false }
//        
//        // This is the condition: Invalidate ONLY if the width of the collection view has changed.
//        // This handles device rotation or changes in the parent's frame size that alter the column width.
//        let invalidate = newBounds.width != collectionView.bounds.width
//        
//        if invalidate {
//            print("StaggeredGridLayout.shouldInvalidateLayout: Invalidating layout due to width change (\(collectionView.bounds.width) -> \(newBounds.width)).")
//            // Crucial: Clear internal caches (`cache` and `columnHeights`) here.
//            // This forces `prepare()` to run a full recalculation and re-measure all items
//            // with the new column width when `invalidateLayout()` is processed.
//            cache.removeAll()
//            columnHeights.removeAll()
//            currentLayoutContentWidth = 0 // Reset this to ensure `prepare()` logic sees a change
//            
//            delegate?.staggeredGridLayoutDidInvalidateLayoutDueToWidthChange(self)
//        } else {
//            // This path means only the scroll offset (bounds.origin) changed, not the size.
//            // For a performant staggered grid, we do NOT need to re-layout on just scrolling.
//            print("StaggeredGridLayout.shouldInvalidateLayout: Not invalidating layout (only scroll position changed).")
//        }
//        // Return `true` if invalidation is needed, `false` otherwise.
//        return invalidate
//    }
//}
//
//// MARK: - 4. MultiColumnList (SwiftUI UIViewRepresentable)
//
///// A SwiftUI view that wraps a UICollectionView to create a dynamic multi-column list.
///// - Item: Must conform to `Identifiable`.
//struct MultiColumnList<Item: Identifiable>: UIViewRepresentable {
//    var items: [Item]
//    var numberOfColumns: Int
//    /// Closure to provide the SwiftUI view for each item.
//    /// The `CGFloat` parameter is the calculated `columnWidth` for the item.
//    var viewForItem: (Item, CGFloat) -> AnyView
//    /// Callback triggered when an item appears on screen.
//    var onItemAppear: ((_ index: Int, _ item: Item) -> Void)?
//
//    /// Creates the Coordinator which acts as UICollectionView's delegate and data source.
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    /// Creates the UICollectionView instance. This is called only once.
//    func makeUIView(context: Context) -> UICollectionView {
//        let layout = StaggeredGridLayout(columns: numberOfColumns, delegate: context.coordinator)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(HostingCollectionViewCell.self, forCellWithReuseIdentifier: "HostingCell")
//        collectionView.dataSource = context.coordinator
//        collectionView.delegate = context.coordinator // Set delegate for scroll and appearance callbacks
//        collectionView.backgroundColor = .clear
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.contentInsetAdjustmentBehavior = .always // Handles safe area insets automatically
//        
//        print("MultiColumnList.makeUIView: Created UICollectionView.")
//        return collectionView
//    }
//
//    /// Updates the UICollectionView when SwiftUI state changes.
//    /// This is called frequently.
//    func updateUIView(_ uiView: UICollectionView, context: Context) {
//        context.coordinator.parent = self // Always ensure coordinator's parent reference is up-to-date
//
//        guard let layout = uiView.collectionViewLayout as? StaggeredGridLayout else {
//            fatalError("CollectionView layout is not StaggeredGridLayout")
//        }
//
//        // Check if the number of columns has changed.
//        if layout.columns != numberOfColumns {
//            print("MultiColumnList.updateUIView: Column count changed from \(layout.columns) to \(numberOfColumns). Forcing layout update.")
//            layout.columns = numberOfColumns
//            context.coordinator.itemHeightCache.removeAll() // Clear height cache as new columns mean new item widths/heights
//            // The `shouldInvalidateLayout` method of StaggeredGridLayout will handle clearing its own internal cache
//            // if the _width_ changes, but here we specifically handle column count changes.
//        }
//        
//        // These calls are crucial to inform UICollectionView that its data or layout might have changed.
//        // `invalidateLayout()` marks the layout as dirty, prompting `prepare()` to run.
//        // `reloadData()` forces UICollectionView to refresh its data source and re-query cells.
//        layout.invalidateLayout()
//        DispatchQueue.main.async {
//            uiView.reloadData()
//        }
//        
//        print("MultiColumnList.updateUIView: layout.invalidateLayout() and reloadData() called.")
//    }
//
//    // MARK: - Coordinator Class
//
//    /// The Coordinator acts as the bridge between SwiftUI (`MultiColumnList`) and UIKit (`UICollectionView`).
//    /// It conforms to UICollectionView's protocols and the custom layout's delegate protocol.
//    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, StaggeredGridLayoutDelegate {
//        var parent: MultiColumnList
//        // Cache to store calculated item heights to prevent redundant, expensive measurements.
//        // This cache MUST be cleared by the parent `MultiColumnList` when column widths change.
//        var itemHeightCache: [AnyHashable: CGFloat] = [:]
//
//        init(_ parent: MultiColumnList) {
//            self.parent = parent
//            print("Coordinator: Initialized with parent.")
//        }
//
//        // MARK: UICollectionViewDataSource
//
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            let count = parent.items.count
//            print("Coordinator.collectionView(_:numberOfItemsInSection:): Returning \(count) items.")
//            return count
//        }
//
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HostingCell", for: indexPath) as! HostingCollectionViewCell
//            let item = parent.items[indexPath.item]
//
//            // Calculate the current column width based on the layout's configuration.
//            guard let layout = collectionView.collectionViewLayout as? StaggeredGridLayout else {
//                fatalError("CollectionView layout is not StaggeredGridLayout")
//            }
//            let availableContentWidth = collectionView.bounds.width - layout.sectionInsets.left - layout.sectionInsets.right
//            let totalSpacingInColumns = layout.spacing * CGFloat(layout.columns - 1)
//            let columnWidth = max(0, (availableContentWidth - totalSpacingInColumns) / CGFloat(layout.columns))
//            
//            print("Coordinator.collectionView(_:cellForItemAt:): Item \(indexPath.item) - Calculated columnWidth for cell: \(columnWidth).")
//
//            // Host the SwiftUI view.
//            // `.id(columnWidth)` is crucial: it tells SwiftUI that if `columnWidth` changes,
//            // this specific instance of the SwiftUI view within the cell needs to be re-evaluated/rebuilt.
//            // This ensures your custom views (e.g., image views) receive the new width and can adjust their layout.
//            let itemSwiftUIView = parent.viewForItem(item, columnWidth)
//                .id(item.id.hashValue ^ columnWidth.hashValue) // Force SwiftUI to re-render if its input width changes
//                .eraseToAnyView()
//
//            cell.host(view: itemSwiftUIView)
//            return cell
//        }
//
//        // MARK: UICollectionViewDelegate (for onItemAppear / Visibility Callbacks)
//
//        /// Called just before a cell is displayed. Useful for `onItemAppear` callback.
//        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            guard indexPath.item < parent.items.count else { return }
//            let item = parent.items[indexPath.item]
//            print("Coordinator.collectionView(_:willDisplay:): Item \(indexPath.item) will appear.")
//            parent.onItemAppear?(indexPath.item, item)
//        }
//        
//        /// Called after a cell has been removed from the screen. Useful for resource cleanup.
//        func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//             print("Coordinator.collectionView(_:didEndDisplaying:): Item \(indexPath.item) did disappear.")
//            // You might implement an `onItemDisappear` callback here if needed for specific cleanup.
//        }
//
//        // MARK: StaggeredGridLayoutDelegate
//
//        /// This method is called by `StaggeredGridLayout` to determine each item's height.
//        /// It is the most critical part for correctly sizing SwiftUI views within the grid.
//        func staggeredGridLayout(_ layout: StaggeredGridLayout, heightForItemAtIndexPath indexPath: IndexPath, columnWidth: CGFloat) -> CGFloat {
//            guard indexPath.item < parent.items.count else {
//                print("Coordinator.staggeredGridLayout: Index path out of bounds for item \(indexPath.item). Returning 0 height.")
//                return 0
//            }
//            let item = parent.items[indexPath.item]
//
//            // Check the cache first to avoid redundant, expensive SwiftUI view measurements.
//            // The cache is cleared when `MultiColumnList` detects a column count or width change.
//            if let cachedHeight = itemHeightCache[item.id] {
//                print("Coordinator.staggeredGridLayout: Using cached height \(cachedHeight) for item \(indexPath.item) at width \(columnWidth).")
//                return cachedHeight
//            }
//
//            print("Coordinator.staggeredGridLayout: Measuring item \(indexPath.item) for height at columnWidth: \(columnWidth).")
//
//            // Create a dummy `UIHostingController` to measure the SwiftUI view's intrinsic size.
//            // It is absolutely critical that this "dummy" view receives the *exact same inputs*
//            // (the `item` and the `columnWidth`) as the view that will be displayed in the actual cell.
//            let dummySwiftUIView = parent.viewForItem(item, columnWidth)
//                .id(item.id.hashValue ^ columnWidth.hashValue) // Ensure consistency with the actual cell for measurement
//                .eraseToAnyView()
//
//            let dummyHostingController = UIHostingController(rootView: dummySwiftUIView)
//            // Prevent the dummy view from trying to use its own Auto Layout constraints for its overall size.
//            dummyHostingController.view.translatesAutoresizingMaskIntoConstraints = false
//
//            // Use `systemLayoutSizeFitting` to ask the SwiftUI view how big it wants to be.
//            // We give it the fixed `columnWidth` (`.required` horizontal priority)
//            // and let it determine its own height (`.fittingSizeLevel` vertical priority).
//            let targetSize = CGSize(width: columnWidth, height: UIView.layoutFittingExpandedSize.height)
//            let fittingSize = dummyHostingController.view.systemLayoutSizeFitting(
//                targetSize,
//                withHorizontalFittingPriority: .required,
//                verticalFittingPriority: .fittingSizeLevel
//            )
//
//            let calculatedHeight = fittingSize.height
//            print("Coordinator.staggeredGridLayout: Measured height for item \(indexPath.item): \(calculatedHeight) at width: \(columnWidth).")
//
//            itemHeightCache[item.id] = calculatedHeight // Cache the calculated height for future use
//            return calculatedHeight
//        }
//        
//        func staggeredGridLayoutDidInvalidateLayoutDueToWidthChange(_ layout: StaggeredGridLayout) {
//            print("Coordinator: Layout invalidated due to width change. Clearing item height cache.")
//            itemHeightCache.removeAll()
//        }
//    }
//}
//
//extension View {
//    /// Type-erases a view, necessary for UIHostingController's `rootView`.
//    func eraseToAnyView() -> AnyView {
//        AnyView(self)
//    }
//}

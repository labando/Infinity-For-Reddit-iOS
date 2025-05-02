//
//  ScrollTargetBehavior.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-02.
//

import SwiftUI

extension ScrollTargetBehavior where Self == CustomPagingBehavior {
    static var customPaging: CustomPagingBehavior { .init() }
}

struct CustomPagingBehavior: ScrollTargetBehavior {
    enum Direction {
        case left, right, up, down, none
    }

    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        // Check available axes
        let horizontalAvailable = context.axes.contains(.horizontal)
        let verticalAvailable = context.axes.contains(.vertical)

        guard horizontalAvailable || verticalAvailable else { return }

        // Determine active axis
        let horizontalDiff = abs(context.originalTarget.rect.minX - target.rect.minX)
        let verticalDiff = abs(context.originalTarget.rect.minY - target.rect.minY)
        let isHorizontal = horizontalDiff > verticalDiff

        // Get relevant dimensions
        let viewSize = isHorizontal ? context.containerSize.width : context.containerSize.height
        let contentSize = isHorizontal ? context.contentSize.width : context.contentSize.height

        guard contentSize > viewSize else {
            if isHorizontal {
                target.rect.origin.x = 0
            } else {
                target.rect.origin.y = 0
            }
            return
        }

        let originalOffset = isHorizontal ? context.originalTarget.rect.minX : context.originalTarget.rect.minY
        let targetOffset = isHorizontal ? target.rect.minX : target.rect.minY

        // Use original direction logic but extend to vertical
        let direction: Direction
        if isHorizontal {
            direction = targetOffset > originalOffset ? .left : (targetOffset < originalOffset ? .right : .none)
        } else {
            direction = targetOffset > originalOffset ? .up : (targetOffset < originalOffset ? .down : .none)
        }

        guard direction != .none else {
            if isHorizontal {
                target.rect.origin.x = originalOffset
            } else {
                target.rect.origin.y = originalOffset
            }
            return
        }

        // Use existing calculation logic but with abstracted parameters
        let remaining: CGFloat
        if isHorizontal {
            remaining = (direction == .left)
                ? (contentSize - context.originalTarget.rect.maxX)
                : context.originalTarget.rect.minX
        } else {
            remaining = (direction == .up)
                ? (contentSize - context.originalTarget.rect.maxY)
                : context.originalTarget.rect.minY
        }

        let thresholdRatio: CGFloat = 1 / 3
        let threshold = remaining <= viewSize ? remaining * thresholdRatio : viewSize * thresholdRatio

        let dragDistance = originalOffset - targetOffset
        var destination: CGFloat = originalOffset

        if abs(dragDistance) > threshold {
            destination = dragDistance > 0 ? originalOffset - viewSize : originalOffset + viewSize
        } else {
            if direction == .right || direction == .down {
                destination = ceil(originalOffset / viewSize) * viewSize
            } else {
                destination = floor(originalOffset / viewSize) * viewSize
            }
        }

        let maxOffset = contentSize - viewSize
        let boundedDestination = min(max(destination, 0), maxOffset)

        if boundedDestination >= maxOffset * 0.95 {
            destination = maxOffset
        } else if boundedDestination <= viewSize * 0.05 {
            destination = 0
        } else {
            if direction == .right || direction == .down {
                let offsetFromEnd = maxOffset - boundedDestination
                let pageFromEnd = round(offsetFromEnd / viewSize)
                destination = maxOffset - (pageFromEnd * viewSize)
            } else {
                let pageNumber = round(boundedDestination / viewSize)
                destination = min(pageNumber * viewSize, maxOffset)
            }
        }

        // Apply calculated destination to correct axis
        if isHorizontal {
            target.rect.origin.x = destination
        } else {
            target.rect.origin.y = destination
        }
    }
}

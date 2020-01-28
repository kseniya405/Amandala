//
//  LinkedList.swift
//  Amandala
//
//  Created by Ксения Шкуренко on 09.11.2017.
//  Copyright © 2017 Kseniia Shkurenko. All rights reserved.
//

import CoreGraphics
import UIKit

/// An object that contains the user's touch point, previous and next colors
struct MoveNode {
    var point: CGPoint?
    var previosColor: UIColor?
    var nextColor: UIColor?
}


/// Bidirectional list of items
public final class LinkedList<T> {
    
    public class LinkedListNode<T> {
        var value: T
        var next: LinkedListNode?
        weak var previous: LinkedListNode?
        
        public init(value: T) {
            self.value = value
        }
    }
    
    public typealias Node = LinkedListNode<T>
    
    fileprivate var head: Node?
    
    public init() {}
    
    /// indicates whether the LinkedList is empty
    public var isEmpty: Bool {
        return head == nil
    }
    
    /// first list item
    public var first: Node? {
        return head
    }
    
    /// last list item
    public var last: Node? {
        if var node = head {
            while let next = node.next {
                node = next
            }
            return node
        } else {
            return nil
        }
    }
    
    /// how many items are in the list
    public var count: Int {
        if var node = head {
            var c = 1
            while let next = node.next {
                node = next
                c += 1
            }
            return c
        } else {
            return 0
        }
    }
    
    
    /// adds an item to the list
    public func append(_ value: T) {
        let newNode = Node(value: value)
        self.append(newNode)
    }
    
    /// adds an item to the list
    public func append(_ node: Node) {
        let newNode = LinkedListNode(value: node.value)
        if let lastNode = last {
            newNode.previous = lastNode
            lastNode.next = newNode
        } else {
            head = newNode
        }
    }

    /// clears the list
    public func removeAll() {
        head = nil
    }
    
    
    /// returns and deletes the given Node
    /// - Parameter node: node to be deleted and returned
    @discardableResult public func remove(node: Node) -> T {
        let prev = node.previous
        let next = node.next

        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        next?.previous = prev

        node.previous = nil
        node.next = nil
        return node.value
    }
    
    /// returns and deletes the last element
    @discardableResult public func removeLast() -> T? {
        guard last != nil else { return nil }
        return remove(node: last!)
    }
    
    /// returns and deletes the first element
    @discardableResult public func removeFirst() -> T? {
        guard first != nil else { return nil }
        return remove(node: first!)
    }
}



public func removeDuplicates<C: ExtensibleCollectionType where C.Generator.Element : Equatable>(aCollection: C) -> C {
    var container = C()
    
    for element in aCollection {
        if !contains(container, element) {
            container.append(element)
        }
    }
    
    return container
}
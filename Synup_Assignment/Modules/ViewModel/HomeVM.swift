//
//  HomeVM.swift
//  Synup_Assignment
//
//  Created by cronycle on 25/08/2019.
//  Copyright © 2019 Apoorv. All rights reserved.
//

import Foundation

class HomeVM {
    private var groups : [Group] = []
    private var exclusions : [[Exclusion]] = [[]]
    private var groupsService : GroupsService?
    typealias VariantCellConfigurator = TableCellConfigurator<VariantTableViewCell,Variant>
    /*
     Input
     */
    var showHideLoader : ((_ show : Bool) -> Void)?
    var refreshUI : (() -> Void)?
    func viewDidLoad(){
        getGroups()
    }
    
    /*
     Output
     */
    var selectedVariations : [Variant] = []
    func sectionItems() -> [Group] {
        return groups
    }
    func rowItems(inSection section : Int) -> [Variant] {
        return groups[section].variants
    }
    func rowCellItems(forSection section : Int) -> [VariantCellConfigurator] {
        return groups[section].variants.compactMap({VariantCellConfigurator(item: $0)})
    }
    func item(forIndexPath indexPath : IndexPath) -> Variant {
        return groups[indexPath.section].variants[indexPath.row]
    }
    func item(forSection section : Int) -> Group {
        return groups[section]
    }
    func add(variant : Variant) {
        if let currentVariantFromGroup = selectedVariations.first(where: {$0.group.id == variant.group.id})
            , let index = selectedVariations.firstIndex(where: {$0.id == currentVariantFromGroup.id}) {
            if currentVariantFromGroup.id == variant.id {
                // Do nothing
            } else {
                selectedVariations.remove(at: index)
                selectedVariations.append(variant)
                refreshUI?()
            }
        } else {
            selectedVariations.append(variant)
            refreshUI?()
        }
    }
    func considerDefault(forSection section : Int)-> Bool {
        let sectionGroupID = item(forSection: section).id
        if selectedVariations.contains(where: {$0.group.id == sectionGroupID}) {
            return false
        }
        return true
    }
    func canSelect(item : Variant) -> (Bool, String?) {
        var toBeSelectedVariants = Set(selectedVariations + [item])
        if let currentVariantFromGroup = selectedVariations.first(where: {$0.group.id == item.group.id}){
            toBeSelectedVariants.remove(currentVariantFromGroup)
        }
        for exclusionArray in  exclusions {
            let arr = variants(forExclusions: exclusionArray)
            let variantCombinations = Set(arr)
            if toBeSelectedVariants.intersection(variantCombinations) == variantCombinations{
                return (false, "You cannot select a combination of " + arr.compactMap({$0.name}).joined(separator: " and "))
            }
        }
        return (true,nil)
    }
    private func variants(forExclusions exclusions : [Exclusion]) -> [Variant]{
        return exclusions.compactMap({variant(forExclusion: $0)})
    }
    private func variant(forExclusion exclusion : Exclusion)-> Variant? {
        let groupForVariant = groups.first(where: {$0.id == exclusion.groupID})
        return groupForVariant?.variants.first(where: {$0.id == exclusion.variationID})
    }
    private func addDefaultVariations(){
        let defaultSelectedVariants = groups.flatMap({$0.variants.filter({$0.isDefault})})
        selectedVariations += defaultSelectedVariants
        refreshUI?()
    }
    private func getGroups() {
        groupsService = GroupsService.init()
        showHideLoader?(true)
        groupsService?.getGroups(completion: {[unowned self] (groups,exclusions, error) in
            if let groups = groups {
                self.groups = groups
                if let exclusions = exclusions {
                    self.exclusions = exclusions
                }
                self.showHideLoader?(false)
                self.addDefaultVariations()
            }
            self.groupsService = nil
        })
    }
}

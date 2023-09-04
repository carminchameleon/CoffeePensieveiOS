//
//  DataManager.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/06.
//

import Foundation
import Firebase
// 모든 데이터를 관리하는 매니저
final class DataManager {
    static let shared = DataManager()
    
    // record list view에 들어가는 데이터 변환 함수
    // [2023-08-29 14:00:00 +0000: [commit, commit...]
    typealias SortedDailyDetailedCommit = [Date: [CommitDetail]]
    func sortDetailedCommitwithCreatedAt(_ commitList: [CommitDetail]) -> SortedDailyDetailedCommit {
        var groupedCommitDetails = [Date: [CommitDetail]]()
        for commitDetail in commitList {
            let date = Calendar.current.startOfDay(for: commitDetail.createdAt)
            if var group = groupedCommitDetails[date] {
                group.append(commitDetail)
                groupedCommitDetails[date] = group
            } else {
                groupedCommitDetails[date] = [commitDetail]
            }
        }
        return groupedCommitDetails
    }

    // TODO: - 다른 곳으로 이동 필요
    // commit 있을 때 그 commit의 해당 데이터들을 묶어줘서 CommitDetail로 만들어주는
    func getCommitDetailInfo(commit: Commit) -> CommitDetail {
        let drink = Constant.drinkList.filter { $0.drinkId == commit.drinkId }[0]
        let mood = Constant.moodList.filter { $0.moodId == commit.moodId }[0]
        var tags: [Tag] = []
        
        commit.tagIds.forEach { tagId in
            let findedTag = Constant.tagList.filter { $0.tagId == tagId}
            if !findedTag.isEmpty {
                tags.append(findedTag[0])
            }
        }

        let commitDatil = CommitDetail(id: commit.id,
                                       uid: commit.uid,
                                       drink: drink,
                                       mood: mood,
                                       tagList: tags,
                                       memo: commit.memo,
                                       createdAt: commit.createdAt)
        return commitDatil
    }
    // TODO: - 다른 곳으로 이동 필요
    // 제일 많이 마신 음료수 뽑기
    func getTopDrinkList(commitList: [Commit]) {
        var drinkCount: [Int: Int] = [:]
        commitList.forEach { commit in
            if let number  = drinkCount[commit.drinkId] {
                drinkCount[commit.drinkId] = number + 1
            } else {
                drinkCount[commit.drinkId] = 1
            }
        }
        let sortedData =  drinkCount.sorted { $0.value > $1.value }
        var index = 0
        let drinkData = sortedData.map { (key: Int, value: Int) in
            let drink = Constant.drinkList.filter { $0.drinkId == key }[0]
            index = index + 1
            return DrinkRanking(ranking: index, drink: drink, number: value)
        }
        let _ = drinkData[0...2]
    }
    
    
}

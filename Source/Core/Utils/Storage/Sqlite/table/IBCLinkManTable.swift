//
//  IBCLinkManTable.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2017/11/15.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit
import SQLite
import JavaScriptCore

class IBCLinkManTable: IBCTableBase {
    /// 只存储string表名
    let identifier: String = {
        return "IBCLinkManTable"
    }()
    
    
    let address             = Expression<String>("address")
    let badgeNumber         = Expression<String>("badgeNumber")
    let birthdayStr         = Expression<String>("birthdayStr")
    let educationBackgroud  = Expression<String>("educationBackgroud")
    let email               = Expression<String>("email")
    let gender              = Expression<Int>("gender")
    let headImgUrl          = Expression<String>("headImgUrl")
    let height              = Expression<Int>("height")
    let hobby               = Expression<String>("hobby")
    let id                  = Expression<Int>("id")
    let idcardNo            = Expression<String>("idcardNo")
    let jobPosition         = Expression<String>("jobPosition")
    let level               = Expression<Int>("level")
    let mobileNo            = Expression<String>("mobileNo")
    let nativePlace         = Expression<String>("nativePlace")
    let orgDomain           = Expression<String>("orgDomain")
    let orgId               = Expression<Int>("orgId")
    let orgName             = Expression<String>("orgName")
    let personalizedSignature = Expression<String>("personalizedSignature")
    let userName            = Expression<String>("userName")
    let userNickName        = Expression<String>("userNickName")
    let userRealName        = Expression<String>("userRealName")
    let userRosterName      = Expression<String>("userRosterName")
    let userTypeId          = Expression<Int>("userTypeId")
    let wechatAccountName   = Expression<String>("wechatAccountName")
    let weight              = Expression<Int>("weight")
    let workArea            = Expression<String>("workArea")
    /// 分组ID
    let groupId = Expression<String>("groupId")
    
    public init() {
        super.init(tableName: identifier + ibcEnvironment.rawValue, columns: [id, address, badgeNumber, birthdayStr, groupId, educationBackgroud, email, gender, headImgUrl, height, hobby, idcardNo, jobPosition, level, mobileNo, nativePlace, orgDomain, orgId, orgName, personalizedSignature, userName, userNickName, userRealName, userRosterName, userTypeId, wechatAccountName, weight, workArea])
    }
    
    /// 将数据库查询到的数据转为Dic
    override func getDic(row: Row) -> Dictionary<String, Any>{
        var dic = Dictionary<String, Any>()
        dic.updateValue(row[id], forKey: "id")
        dic.updateValue(row[address], forKey: "address")
        dic.updateValue(row[badgeNumber], forKey: "badgeNumber")
        dic.updateValue(row[birthdayStr], forKey: "birthdayStr")
        dic.updateValue(row[educationBackgroud], forKey: "educationBackgroud")
        dic.updateValue(row[email], forKey: "email")
        dic.updateValue(row[gender], forKey: "gender")
        dic.updateValue(row[headImgUrl], forKey: "headImgUrl")
        dic.updateValue(row[height], forKey: "height")
        dic.updateValue(row[hobby], forKey: "hobby")
        dic.updateValue(row[idcardNo], forKey: "idcardNo")
        dic.updateValue(row[jobPosition], forKey: "jobPosition")
        dic.updateValue(row[level], forKey: "level")
        dic.updateValue(row[mobileNo], forKey: "mobileNo")
        dic.updateValue(row[nativePlace], forKey: "nativePlace")
        dic.updateValue(row[orgDomain], forKey: "orgDomain")
        dic.updateValue(row[orgId], forKey: "orgId")
        dic.updateValue(row[orgName], forKey: "orgName")
        dic.updateValue(row[personalizedSignature], forKey: "personalizedSignature")
        dic.updateValue(row[userName], forKey: "userName")
        dic.updateValue(row[userNickName], forKey: "userNickName")
        dic.updateValue(row[userRealName], forKey: "userRealName")
        dic.updateValue(row[userRosterName], forKey: "userRosterName")
        dic.updateValue(row[userTypeId], forKey: "userTypeId")
        dic.updateValue(row[wechatAccountName], forKey: "wechatAccountName")
        dic.updateValue(row[weight], forKey: "weight")
        dic.updateValue(row[workArea], forKey: "workArea")
        dic.updateValue(row[groupId], forKey: "groupId")
        
        
        return dic
    }
    
    /// 将model转为[Setter]
    override func getSet(model: IBCModelBase) -> [Setter]{
        if let model = model as? IBCLinkManModel{
            return [id <- model.id, address <- model.address, badgeNumber <- model.badgeNumber, birthdayStr <- model.birthdayStr, groupId <- model.groupId, educationBackgroud <- model.educationBackgroud, email <- model.email, gender <- model.gender, headImgUrl <- model.headImgUrl, height <- model.height, hobby <- model.hobby, idcardNo <- model.idcardNo, jobPosition <- model.jobPosition, level <- model.level, mobileNo <- model.mobileNo, nativePlace <- model.nativePlace, orgDomain <- model.orgDomain, orgId <- model.orgId, orgName <- model.orgName, personalizedSignature <- model.personalizedSignature, userName <- model.userName, userNickName <- model.userNickName, userRealName <- model.userRealName, userRosterName <- model.userRosterName, userTypeId <- model.userTypeId, wechatAccountName <- model.wechatAccountName, weight <- model.weight, workArea <- model.workArea]
        }else{
            return super.getSet(model: model)
        }
    }
}


//
//  IBCLinkManModel.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2017/11/15.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit
import SQLite

open class IBCLinkManModel: IBCModelBase {
    /// 分组ID
    public var groupId: String = ""
    ///详细地址
    public var address: String = ""
    ///工号
    public var badgeNumber: String = ""
    ///生日
    public var birthdayStr: String = ""
    ///教育背景
    public var educationBackgroud: String = ""
    ///邮箱
    public var email: String = ""
    ///性别
    public var gender: Int = 0
    ///头像
    public var headImgUrl: String = ""
    ///身高
    public var height: Int = 0
    ///爱好
    public var hobby: String = ""
    ///用户ID（userId）
    public var id: Int = 0
    ///身份证号
    public var idcardNo: String = ""
    ///职位
    public var jobPosition: String = ""
    ///等级
    public var level: Int = 0
    ///手机号
    public var mobileNo: String = ""
    ///籍贯
    public var nativePlace: String = ""
    ///公司域
    public var orgDomain: String = ""
    ///公司ID
    public var orgId: Int = 0
    ///公司名称
    public var orgName: String = ""
    ///个性签名
    public var personalizedSignature: String = ""
    ///用户名
    public var userName: String = ""
    ///用户昵称
    public var userNickName: String = ""
    ///真实姓名
    public var userRealName: String = ""
    ///花名
    public var userRosterName: String = ""
    ///用户类型ID
    public var userTypeId: Int = 0
    ///微信号
    public var wechatAccountName: String = ""
    ///体重
    public var weight: Int = 0
    ///工作地区
    public var workArea: String = ""
}

//MARK: 网络请求
extension IBCLinkManModel{
    
}
//MARK: 数据库操作
extension IBCLinkManModel{
    /// 查询所有联系人
    ///
    /// - Returns: 联系人集合
    public class func selectAllMan() -> [IBCLinkManModel]{
        let table = IBCLinkManTable.init()
        
        let dics = table.select()
        
        var models = [IBCLinkManModel]()
        
        for dic in dics{
            models.append(IBCLinkManModel.init(dic: dic))
        }
        return models
    }
    
    /// 查询单个联系人信息
    ///
    /// - Parameter userId: 用户ID
    /// - Returns: 返回对象
    public class func selectManWith(userId: Int) -> IBCLinkManModel{
        let table = IBCLinkManTable.init()
        
        let dics = table.selectWith(filter: table.id == userId)
        
        var models = [IBCLinkManModel]()
        
        for dic in dics{
            models.append(IBCLinkManModel.init(dic: dic))
        }
        if models.count != 0{
            return models[0]
        }else{
            return IBCLinkManModel()
        }
        
    }
    
    /// 根据分组ID查询
    ///
    /// - Parameter groupId: 分组ID
    /// - Returns: 结果集
    public class func selectManWith(groupId: Int) -> [IBCLinkManModel]{
        let table = IBCLinkManTable.init()
        
        let dics = table.selectWith(filter: table.groupId.like("%\(groupIdToStr(groupId))%"))
        
        var models = [IBCLinkManModel]()
        
        for dic in dics{
            models.append(IBCLinkManModel.init(dic: dic))
        }
        return models
    }
    
    /// 添加至某分组
    ///
    /// - Parameters:
    ///   - groupId: 目标分组ID
    ///   - models: 数据集
    /// - Returns: 成功状态
    public class func addToGroup(groupId: Int, models: [IBCLinkManModel]) -> Bool{
        let table = IBCLinkManTable.init()
        for model in models{
            if !model.groupId.contains(groupIdToStr(groupId)){
                model.groupId.append(groupIdToStr(groupId))
            }
            let _ = table.update(data: model, filter: table.id == model.id)
        }
        
        return true
    }
    
    /// 从某组删除
    ///
    /// - Parameter models: 删除对象数据
    /// - Returns: 删除状态
    public class func deleteFromGroup(models: [IBCLinkManModel], groupId: Int) -> Bool{
        let table = IBCLinkManTable.init()
        for model in models{
            model.groupId = model.groupId.replacingOccurrences(of: groupIdToStr(groupId), with: "")
            let _ = table.update(data: model, filter: table.id == model.id)
        }
        return true
    }
    
    /// 存储
    ///
    /// - Parameter models: 数据集
    /// - Returns: 结果
    public class func saveLinkMans(models: [IBCLinkManModel]) -> Bool{
        let table = IBCLinkManTable.init()
        
        return table.insert(datas: models)[0]
    }
    
    /// 更新
    ///
    /// - Parameter models: 更新models
    /// - Returns: 成功状态
    public class func updateLinkMans(models: [IBCLinkManModel]) -> Bool{
        let table = IBCLinkManTable.init()
        var sucess = [Bool]()
        for model in models{
            sucess.append(table.update(data: model, filter: table.id == model.id))
        }
        
        return sucess[0]
    }
    
    //转为String存入数据库
    class func groupIdToStr(_ groupId: Int) -> String{
        return "|\(groupId)|"
    }
    
}


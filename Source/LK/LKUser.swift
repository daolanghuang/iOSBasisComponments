//
//  LKUser.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2018/8/9.
//  Copyright © 2018年 Enn. All rights reserved.
//

import UIKit

open class LKUser: IBCModelBase {
    /// 单例
    public static var shared: LKUser = {
        return LKUser.init()
    }()
    /// 是否登录 根据用户ID实时反馈 计算属性
    public var isLogin: Bool{
        if LKUser.shared.id == 0{
            return false
        }
        return true
    }
    /// 用户昵称
    public var userNickName: String = ""
    /// 用户账号
    public var userName: String = ""
    /// 用户ID
    public var id: Int = 0
    /// 用户Token
    public var userToken: String = ""
    /// 手机号
    public var mobileNo: String = ""
    
    
    /// 地址
    public var address: String = ""
    /// 工号
    public var badgeNumber: String = ""
    /// 生日
    public var birthdayStr: String = ""
    /// 备注
    public var comments: String = ""
    /// 创建日期
    public var createdAt: String = ""
    /// 教育背景
    public var educationBackgroud: String = ""
    /// 邮箱
    public var email: String = ""
    /// 性别
    public var gender: Int = 0
    /// 头像
    public var headImgUrl: String = ""
    /// 身高
    public var height: Int = 0
    /// 爱好
    public var hobby: String = ""
    /// 身份证号
    public var idcardNo: String = ""
    /// 职位
    public var jobPosition: String = ""
    /// 用户等级
    public var level: Int = 0
    /// 籍贯
    public var nativePlace: String = ""
    public var orgDomain: String = ""
    public var orgId: Int = 0
    public var orgName: String = ""
    /// 个性签名
    public var personalizedSignature: String = ""
    public var qqUserToken: String = ""
    public var status: Int = 0
    /// 真实姓名
    public var userRealName: String = ""
    /// 花名
    public var userRosterName: String = ""
    public var userTypeId: Int = 0
    public var version: Int = 0
    public var wechatAccountName: String = ""
    public var wechatUserToken: String = ""
    public var weiboUserToken: String = ""
    /// 体重
    public var weight: Int = 0
    /// 工作地
    public var workArea: String = ""
    /// 用户角色 多个角色用逗号分隔, 例如roles="DOCTOR,LAIKANG"
    public var roles: String = ""
    
    /// NIM相关
    public var nimAccId = ""
    public var nimAccToken = ""
    /// 是否注册成功
    public var regFLag = false
    /// 互动
    public var action = ""
    
    /// 第三方账号绑定标识
    public var thirdAcountBindFlag: String = "Yes"
    
    /// 机构编码
    public var orgCode: String = ""
    
    fileprivate let userDataKey: String = {
        return "NLKUserData\(ibcEnvironment.rawValue)"
    }()
    
    /// 初始化方法，如果UserDefau中有数据则取用
    private override init() {
        if let values = UserDefaults.standard.dictionary(forKey: userDataKey){
            super.init(dic: values)
        }else{
            super.init()
        }
    }
    
    /// 存储至UserDefault中
    public func saveToUserDefault(){
        UserDefaults.standard.setValue(self.values(), forKey: userDataKey)
    }
    
    /// 从本地删除
    public func removeFromUserDefault(){
        UserDefaults.standard.removeObject(forKey: userDataKey)
        LKUser.shared = LKUser.init()
    }
    
    /// 根据字典初始化数据
    ///
    /// - Parameter dic: 字典数据
    private override init(dic: Dictionary<String, Any>) {
        super.init(dic: dic)
    }
    
    /// 更新用户数据并存储至本地
    ///
    /// - Parameter dic: 新的数据字典
    public static func updateValues(dic: Dictionary<String, Any>){
        LKUser.shared = LKUser.init(dic: dic)
        LKUser.shared.saveToUserDefault()
    }
    
    /// 判断是否为医生
    public func isDoctor() -> Bool{
        if roles.contains("DOCTOR"){
            return true
        }
        return false
    }
}



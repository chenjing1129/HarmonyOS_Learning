/**
 * UserInfo.ets
 * 简要描述：用户信息数据模型
 * 作者：cj
 * 日期：2025/9/9
 */
export interface UserInfo {
  id: number   //用户id，唯一标识
  name: string
  age: number
  avatar: Resource
  email?: string //可选字段
  active: boolean
}
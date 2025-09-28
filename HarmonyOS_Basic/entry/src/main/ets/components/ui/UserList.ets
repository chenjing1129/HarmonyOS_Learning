/**
 * UserList.ets
 * 简要描述: 用户列表组件
 * 作者: cj
 * 日期: 2025/9/10
 */
import { UserInfo } from '../../model/UserInfo.ets';
import { UserProfile } from './UserProfile';

@Component
export struct UserList {
  // 用户数据数组
  @State users: UserInfo[] = [
    { id: 1, name: '张伟', age: 28, avatar: $r('app.media.avatar'), introduction: '一位经验丰富的HarmonyOS应用开发者，热爱探索新技术，一位经验丰富的HarmonyOS应用开发者，热爱探索新技术，一位经验丰富的HarmonyOS应用开发者，热爱探索新技术。', isDisabled: false },
    { id: 2, name: '李娜', age: 34, avatar: $r('app.media.avatar'), introduction: '专注于用户体验设计和产品管理，追求极致的用户体验。', isDisabled: true },
    { id: 3, name: '王强', age: 25, avatar: $r('app.media.avatar'), introduction: '充满激情的前端工程师，对创造美观且高性能的界面有浓厚兴趣。', isDisabled: false },
    { id: 4, name: '刘洋', age: 31, avatar: $r('app.media.avatar'), introduction: '后端架构师，擅长构建高可用、可扩展的分布式系统。', isDisabled: false },
    { id: 5, name: '陈静', age: 29, avatar: $r('app.media.avatar'), introduction: '数据科学家，致力于从海量数据中挖掘价值，驱动业务增长。', isDisabled: true },
    { id: 6, name: '赵敏', age: 22, avatar: $r('app.media.avatar'), introduction: '新生代UI设计师，拥有独特的创意和设计风格。', isDisabled: false },
    { id: 7, name: '孙悦', age: 38, avatar: $r('app.media.avatar'), introduction: '资深项目经理，具备卓越的团队领导和项目交付能力。', isDisabled: false },
    { id: 8, name: '周鹏', age: 42, avatar: $r('app.media.avatar'), introduction: '全栈开发者，对技术充满热情，喜欢挑战复杂问题。', isDisabled: true },
    { id: 9, name: '吴迪', age: 26, avatar: $r('app.media.avatar'), introduction: '移动应用测试专家，确保应用的质量和稳定性。', isDisabled: false },
    { id: 10, name: '郑凯', age: 33, avatar: $r('app.media.avatar'), introduction: 'DevOps工程师，自动化部署和运维流程的倡导者。', isDisabled: true },
    { id: 11, name: '冯薪', age: 27, avatar: $r('app.media.avatar'), introduction: '游戏开发者，创造有趣和富有挑战性的游戏世界。', isDisabled: false },
    { id: 12, name: '褚卫', age: 30, avatar: $r('app.media.avatar'), introduction: '信息安全专家，保护系统和数据免受网络威胁。', isDisabled: false }
  ];

  build() {
    Column() {
      List({ space: 10 }) {
        ForEach(
          this.users,
          (user: UserInfo) => {
            ListItem() {
              UserProfile({ initialUser: user })
            }
          },
          (user: UserInfo) => user.id.toString()
        )
      }
      .divider({ strokeWidth: 1, color: '#00000000' }) // 设置分割线为透明
      .listDirection(Axis.Vertical) // 垂直滚动
      .layoutWeight(1) // 占据剩余空间
    }
    .width('100%')
    .padding({top: 0, bottom: 0, left: 16, right: 16})
    .backgroundColor(Color.Transparent)
  }
}

@Preview
@Component
struct UserListPreview {
  build() {
    Column() {
      UserList()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .justifyContent(FlexAlign.Center)
  }
} 
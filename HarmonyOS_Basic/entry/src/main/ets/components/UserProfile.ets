/**
 * UserProfile.ets
 * 简要描述: 单个用户信息的展示组件
 * 作者: cj
 * 日期: 2025/9/10
 */
import { UserInfo } from '../model/UserInfo.ets';
import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';

@Component
export struct UserProfile {
  // 从父组件接收初始用户数据
  @Prop initialUser: UserInfo;
  // 在组件内部使用@State来管理自己的状态
  @State user: UserInfo = {} as UserInfo;

  // 在组件即将显示时，将传入的Prop数据复制到内部State
  aboutToAppear() {
    // 手动复制对象属性，避免使用ArkTS不支持的对象展开语法
    this.user = {
      id: this.initialUser.id,
      name: this.initialUser.name,
      age: this.initialUser.age,
      avatar: this.initialUser.avatar,
      introduction: this.initialUser.introduction,
      isDisabled: this.initialUser.isDisabled
    };
  }

  build() {
    Column({ space: 10 }) {
      // 头像
      Image(this.user.avatar)
        .width(80)
        .height(80)
        .borderRadius(40)
        .objectFit(ImageFit.Cover)

      // 用户姓名
      Text(this.user.name)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')

      // 用户年龄
      Text(`年龄: ${this.user.age}`)
        .fontSize(14)
        .fontColor('#888888')

      // 个人简介
      Text(this.user.introduction)
        .fontSize(12)
        .fontColor('#AAAAAA')
        .width('90%')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 5, bottom: 5 })

      // 分隔线 - 设置宽度以匹配按钮，优化视觉对齐
      Divider().margin({ top: 5, bottom: 5 }).strokeWidth(1).color('#F0F0F0').width('90%')

      // 操作按钮行
      Row({ space: 10 }) {
        // 禁用按钮
        Button(this.user.isDisabled ? '已禁用' : '禁用')
          .type(ButtonType.Normal)
          .backgroundColor(this.user.isDisabled ? '#B3B3B3' : '#FF4D4F')
          .fontColor(Color.White)
          .fontSize(14)
          .onClick(() => {
            this.user.isDisabled = !this.user.isDisabled;
          })
          .layoutWeight(1) // 占据剩余空间

        // 复制简介按钮
        Button('复制简介')
          .type(ButtonType.Normal)
          .backgroundColor('#007DFF')
          .fontColor(Color.White)
          .fontSize(14)
          .onClick(() => {
            // 1. 创建剪切板数据
            let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, this.user.introduction);
            // 2. 写入剪切板
            pasteboard.getSystemPasteboard().setPasteData(pasteData, (err, data) => {
              if (err) {
                promptAction.showToast({ message: '复制失败' });
                return;
              }
              promptAction.showToast({ message: '简介已复制到剪切板' });
            });
          })
          .layoutWeight(1) // 占据剩余空间
      }
      .width('90%')
      .height(36)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .shadow({ radius: 6, color: '#0000001A', offsetX: 2, offsetY: 2 })
    .alignItems(HorizontalAlign.Center)
  }
} 
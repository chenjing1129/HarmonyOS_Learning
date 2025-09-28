/**
 * ProfileCard.ets
 * 简要描述: 个人信息卡片组件，展示用户基本信息
 * 作者: cj
 * 日期: 2025/9/9
 */

import { ProfileData } from '../../viewmodel/ProfileData';

@Component
export struct ProfileCard {
  @Prop profile: ProfileData;

  build() {
    Column() {
      Image(this.profile.avatar)
        .width(100)
        .height(100)
        .borderRadius(50)
        .margin({ bottom: 10 })
      Text(this.profile.name)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
      Text(this.profile.bio)
        .fontSize(16)
        .fontColor(Color.Gray)
        .margin({ top: 5 })
    }
    .padding(20)
    .borderRadius(15)
    .backgroundColor(Color.White)
    .shadow({ radius: 10, color: '#40000000', offsetX: 5, offsetY: 5 })
    .alignItems(HorizontalAlign.Center)
  }
}

@Preview
@Component
struct ProfileCardPreview {
  build() {
    Column({ space: 20 }) {
      ProfileCard({
        profile: new ProfileData(
          "HarmonyOS Developer",
          $r('app.media.avatar'),
          "This is a sample profile card built as a custom component."
        )
      })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#f1f3f5')
  }
} 
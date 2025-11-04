import { AppStorageMap, PreferenceUtil, RouterMap, RouterModule } from 'basic';
import { common } from '@kit.AbilityKit';

/**
 * 隐私政策页面Builder函数
 */
@Builder
export function PrivacyPolicyPageBuilder() {
  PrivacyPolicyPage()
}

/**
 * 隐私政策页面组件
 */
@ComponentV2
struct PrivacyPolicyPage {
  build() {
    NavDestination() {
      Column() {
        // 标题栏
        Text('隐私政策')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 48, bottom: 16 })

        // 隐私政策内容
        Scroll() {
          Column({ space: 16 }) {
            Text('欢迎使用高途学习应用')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)

            Text('我们非常重视您的隐私保护。本隐私政策将告知您我们如何收集、使用和保护您的个人信息。')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Text('1. 信息收集')
              .fontSize(15)
              .fontWeight(FontWeight.Medium)

            Text('我们可能收集您的学习记录、课程偏好等信息，以便为您提供更好的学习体验。')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Text('2. 信息使用')
              .fontSize(15)
              .fontWeight(FontWeight.Medium)

            Text('您的信息将仅用于改善服务质量，我们不会向第三方出售您的个人信息。')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Text('3. 信息保护')
              .fontSize(15)
              .fontWeight(FontWeight.Medium)

            Text('我们采用业界标准的安全措施保护您的信息安全。')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
        .layoutWeight(1)
        .padding({ left: 16, right: 16 })

        // 底部按钮
        Row({ space: 12 }) {
          Button('取消')
            .layoutWeight(1)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.warning'))
            .backgroundColor($r('sys.color.background_secondary'))
            .onClick(() => {
              // 获取上下文：通过getContext(this)获取当前UIAbility的上下文，并强制转换为UIAbilityContext类型
              // 终止应用：调用terminateSelf()方法关闭当前的应用程序实例
              // 简单来说，这段代码的作用就是退出当前应用程序。
              let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
              context.terminateSelf()
            })
          Button('同意')
            .layoutWeight(1)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_on_primary'))
            .backgroundColor($r('sys.color.warning'))
            .onClick(() => {
              // PreferenceUtil.getInstance().put(AppStorageMap.PRIVACY_POLICY_KEY, '1') - 将隐私政策键值为'1'，表示用户已同意隐私政策
              // RouterModule.replace(RouterMap.MAIN_PAGE) - 跳转到主页面，替换当前路由
              // 🎯常用于用户同意隐私政策后的页面跳转以状态保存。
              PreferenceUtil.getInstance().put(AppStorageMap.PRIVACY_POLICY_KEY, '1')
              RouterModule.replace(RouterMap.MAIN_PAGE)
            })
        }
        .width('100%')
        .padding(16)
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}


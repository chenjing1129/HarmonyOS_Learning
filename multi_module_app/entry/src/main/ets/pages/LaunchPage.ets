import { AppStorageMap, Logger, PreferenceUtil, RouterMap, RouterModule } from 'basic';

@Builder
export function LaunchPageBuilder() {
  LaunchPage()
}

@ComponentV2
struct LaunchPage {
  aboutToAppear(): void {
    setTimeout(() => {
      let privacyState = PreferenceUtil.getInstance().get(AppStorageMap.PRIVACY_POLICY_KEY, '0')
      Logger.info('LaunchPage', `隐私政策状态: ${privacyState}`)
      if (privacyState === '1') {
        Logger.info('LaunchPage', '用户已同意隐私政策，跳转到主页')
        RouterModule.replace(RouterMap.MAIN_PAGE)
      } else {
        Logger.info('LaunchPage', '用户未同意隐私政策，跳转到隐私政策页')
        RouterModule.replace(RouterMap.PRIVACY_POLICY_PAGE)
      }
    }, 2000)
  }

  build() {
    NavDestination() {
      Column() {
        Image($r('app.media.logo'))
          .width(120)
          .height(120)

        Column() {
          Text('高途')
            .fontSize(24)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.primary_blue'))

          Text('开启学习之旅')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))
        }
        .margin({ top: 32 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.White)
    }
    .hideTitleBar(true)
    .backgroundColor(Color.White)
  }
}
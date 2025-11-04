/**
 * 我的页面Builder函数
 */
@Builder
export function ProfilePageBuilder() {
  MainPage()
}

/**
 * 我的页面组件
 */
@Component
export struct MainPage {
  @State message: string = '我的页面';

  build() {
    Column() {
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

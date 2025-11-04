/**
 * 学习页面Builder函数
 */
@Builder
export function LearnPageBuilder() {
  MainPage()
}

/**
 * 学习页面组件
 */
@Component
export struct MainPage {
  @State message: string = '学习页面';

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

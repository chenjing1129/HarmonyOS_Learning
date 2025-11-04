/**
 * 课程页面Builder函数
 */
@Builder
export function CoursePageBuilder() {
  MainPage()
}

/**
 * 课程页面组件
 */
@Component
export struct MainPage {
  @State message: string = '课程页面';

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

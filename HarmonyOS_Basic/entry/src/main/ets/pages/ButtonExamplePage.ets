// entry/src/main/ets/pages/ButtonExamplePage.ets
@Entry
@Component
struct ButtonExamplePage {
  @State count: number = 0

  build() {
    Column({ space: 20 }) {
      // 普通按钮
      Button('普通按钮')
        .onClick(() => {
          this.count++
        })

      // 显示点击次数
      Text(`点击次数: ${this.count}`)
        .fontSize(20)

      // 胶囊按钮
      Button('胶囊按钮', { type: ButtonType.Capsule })
        .width(200)

      // 圆形按钮
      Button({ type: ButtonType.Circle }) {
        Image($r('app.media.avatar'))
          .width(50)
          .height(50)
      }
      .width(60)
      .height(60)

      // 自定义样式按钮
      Button() {
        Column() {
          Text('自定义').fontSize(16)
          Text('按钮').fontSize(12)
        }
      }
      .width(100)
      .height(60)
      .backgroundColor(Color.Pink)
      .borderRadius(10)

    }.width('100%').height('100%').padding(20).justifyContent(FlexAlign.Center)
  }
} 
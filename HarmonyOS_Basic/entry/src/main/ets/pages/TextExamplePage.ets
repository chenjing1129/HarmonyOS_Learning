// entry/src/main/ets/pages/TextExamplePage.ets
@Entry
@Component
struct TextExamplePage {
  build() {
    Column({ space: 10 }) {
      Text('普通文本')
        .fontSize(20)

      Text('红色文本')
        .fontSize(20)
        .fontColor(Color.Red)

      Text('加粗文本')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)

      Text('斜体文本')
        .fontSize(20)
        .fontStyle(FontStyle.Italic)

      Text('下划线文本')
        .fontSize(20)
        .decoration({ type: TextDecorationType.Underline, color: Color.Black })

      Text('多行文本多行文本多行文本多行文本多行文本多行文本多行文本。')
        .fontSize(20)
        .width('90%')
        .textAlign(TextAlign.Center)

    }.width('100%').height('100%').padding(20).justifyContent(FlexAlign.Center)
  }
} 
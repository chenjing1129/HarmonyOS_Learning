// entry/src/main/ets/pages/ListExamplePage.ets
@Entry
@Component
struct ListExamplePage {
  private data: string[] = ['列表项 1', '列表项 2', '列表项 3', '列表项 4', '列表项 5']

  build() {
    Column() {
      Text('基础列表')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .padding(10)

      List({ space: 10 }) {
        ForEach(this.data, (item: string) => {
          ListItem() {
            Text(item)
              .width('100%')
              .fontSize(18)
              .padding(20)
              .backgroundColor(Color.White)
              .borderRadius(10)
              .textAlign(TextAlign.Center)
          }
        })
      }
      .width('90%')
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: '#f1f1f1' }) // 设置分割线
    }.width('100%').height('100%').padding(10).backgroundColor('#f1f1f1')
  }
} 
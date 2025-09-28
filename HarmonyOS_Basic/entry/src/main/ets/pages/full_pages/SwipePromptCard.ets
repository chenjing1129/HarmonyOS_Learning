@Entry
@Component
struct SwipePromptCard {
  @State isExpanded: boolean = false

  build() {
    Column() {
      Column() {
      }
      .width('100%')
      .layoutWeight(1)

      Column() {
        Row() {
          Text('今日待办')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          Blank()
        }
        .width('100%')
        .padding({ left: 16, right: 16 })

        if (this.isExpanded) {
          Column({ space: 12 }) {
            Row() {
              Text('○')
                .fontSize(16)
                .fontColor(Color.White)
              Text('完成滑动卡片')
                .fontSize(16)
                .fontColor(Color.White)
                .margin({ left: 8 })
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)

            Row() {
              Text('○')
                .fontSize(16)
                .fontColor(Color.White)
              Text('查看官方文档')
                .fontSize(16)
                .fontColor(Color.White)
                .margin({ left: 8 })
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)

            Row() {
              Text('○')
                .fontSize(16)
                .fontColor(Color.White)
              Text('完成作业')
                .fontSize(16)
                .fontColor(Color.White)
                .margin({ left: 8 })
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16 })
        }
      }
      .width('90%')
      .backgroundColor('#FF666666')
      .borderRadius(12)
      .padding({ top: 16, bottom: 16 })
      .margin({ 
        left: '5%', 
        right: '5%',
        bottom: this.isExpanded ? '80%' : 40
      })
      .animation({
        duration: 800,
        curve: Curve.EaseInOut
      })
      .onClick(() => {
        this.isExpanded = !this.isExpanded
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF5F5F5')
  }
}

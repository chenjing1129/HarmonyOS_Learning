// entry/src/main/ets/pages/ImageExamplePage.ets
@Entry
@Component
struct ImageExamplePage {
  build() {
    Column({ space: 20 }) {
      Text('本地图片示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Image($r('app.media.avatar'))
        .width(100)
        .height(100)
        .borderRadius(20)
        .border({ width: 2, color: Color.Black })
        .alt('图片加载失败') // 设置加载失败时显示的文本

      Text('网络图片示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Image('https://tse2.mm.bing.net/th/id/OIP.tHAIAaw4ZNlr4v2ldAkvYwHaHa?r=0&cb=ucfimgc2&rs=1&pid=ImgDetMain&o=7&rm=3')
        .width(200)
        .height(100)
        .objectFit(ImageFit.Contain) // 设置图片缩放模式
        .interpolation(ImageInterpolation.High) // 设置图片插值质量
        .onComplete(() => {
          console.info('网络图片加载完成')
        })
        .onError(() => {
          console.error('网络图片加载失败')
        })

    }.width('100%').height('100%').padding(20).justifyContent(FlexAlign.Center)
  }
} 
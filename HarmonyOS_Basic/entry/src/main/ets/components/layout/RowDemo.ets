@Preview
@Component
export struct RowDemo {
  build() {
    Row({space:8}){
      //1.图片
      Image($r("app.media.avatar"))
        .width(24)
        .height(24)


      //2.文本框
      Text('鸿蒙开发').fontSize(12).fontWeight(FontWeight.Medium)
        .layoutWeight(1)

      //3.按钮
      Button('详情').type(ButtonType.Capsule).width(60).height(20)
    }.padding({left:20,right:20})
    .width(300)
    .height(40)
    .backgroundColor('#ff5d91bf')
  }
}
@Preview
@Component
export struct ColumnDemo {
  build() {
    Column({space:8}){
      //1.文本签到
      Text('签到').fontSize(24).fontWeight(FontWeight.Bold)


      //2.文本 提醒
      Text('上课前5分钟扫码签到上课前5分钟扫码签到上课前5分钟扫码签到上课前5分钟扫码签到上课前5分钟扫码签到上课前5分钟扫码签到上课前5分钟扫码签到上课前5分钟扫码签到上课前5分钟扫码签到上课前5分钟扫码签到上课前5分钟扫码签到上课前5分钟扫码签到上课前5分钟扫码签到上课前5分钟扫码签到').fontSize(14).fontColor("#666").maxLines(2)

      //3.按钮
      Button('提醒').margin({top:12}).onClick(()=>{
        console.log("运行签到")
      })
    }
    .width('100%')
    .backgroundColor("#ff224c8a")
    .borderRadius(12)
    .shadow({radius:8,color:'#f00'})
  }
}
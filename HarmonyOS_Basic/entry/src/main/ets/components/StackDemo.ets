@Component
@Preview
export struct StackDemo {
  @Prop avatarUrl: string = 'https://tse2-mm.cn.bing.net/th/id/OIP-C.m1REnjvhN1f0PVgJsK3iggAAAA?w=169&h=180&c=7&r=0&o=7&dpr=2&pid=1.7&rm=3'
  @Prop username: string = '张三'
  @State hasNewMsg: boolean = true // 是否有消息

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      // 底层：头像
      Image(this.avatarUrl || $r('app.media.startIcon'))
        .width(60)
        .height(60)
        .borderRadius(30)
        .border({
          width: 2,
          color: Color.Red
        })

      // 消息徽章背景，红色圆定位到右上角
      if (this.hasNewMsg) {
        Circle({ width: 18, height: 18 })
          .fill(Color.Red)
          .position({ x: 50, y: 0 })

        Text('8')
          .fontSize(10)
          .fontColor(Color.White)
          .position({ x: 55, y: 4 }) // 文字居中
      }

      // 姓名
      Text(this.username)
        .fontSize(14)
        .fontColor(Color.Black)
        .position({ x: 8, y: 65 })
        .width(60)
        .textAlign(TextAlign.Center)
    }
    .width(78)
    .height(85)
  }
}
@Preview
@Component
export struct FlexDemo {
  @State skills: string[] = ['项目管理', 'java', 'vue', 'Python', 'javascript', '鸿蒙开发', 'ui设计']

  build() {
    Flex({
      direction: FlexDirection.Row, //水平排列
      wrap: FlexWrap.Wrap, //允许换行
      justifyContent: FlexAlign.Start //左对齐
    }) {
      ForEach(this.skills, (skill:
        string, index: number) => {
        Text(skill)
          .fontSize(14)
          .fontColor('#333')
          .backgroundColor('#f1f2f3')
          .padding({
            left: 12,
            right: 12,
            top: 4,
            bottom: 4
          })
          .borderRadius(12)
          .margin({ right: 8, bottom: 8 }) //标签之间的距离
      })
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#fff')
    .borderRadius(12)
    .margin({right:8,bottom:8})
  }
}
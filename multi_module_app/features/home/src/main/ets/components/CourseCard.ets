import { CourseInfo } from '../types/Index'

@ComponentV2
export struct CourseCard {
  @Param courseInfo: CourseInfo = new CourseInfo()
  @Event jumpCourseDetail: (id: number, title: string) => void = () => {
  }

  build() {
    Column({ space: 12 }) {
      // 课程图片
      Image(this.courseInfo.thumbnail)
        .width('100%')
        .height(100)
        .borderRadius(8)
        .margin({ right: 12 })

      // 课程标题
      Text(this.courseInfo.title)
        .fontSize(14)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('90%')

      Row() {
        // 讲师信息
        Text(this.courseInfo.instructor)
          .fontSize(14)
          .fontColor('#666666')
          .margin({ top: 4 })
          .flexGrow(1)

        // 评分信息
        Row() {
          Image($r('app.media.ic_star'))
            .width(16)
            .height(16)
          Text(this.courseInfo.rating.toString())
            .fontSize(14)
            .margin({ left: 4 })
        }
      }
    }
    .width('100%')
    .backgroundColor($r('sys.color.background_primary'))
    .alignItems(HorizontalAlign.Start)
    .borderRadius(12)
    .padding(12)
    .shadow({
      radius: 6,
      color: '#1F000000',
      offsetX: 0,
      offsetY: 2
    })
    .onClick(() => {
      this.jumpCourseDetail(this.courseInfo.id, this.courseInfo.title)
    })
  }
}

import { Logger, RouterMap, RouterModule } from 'basic';
import { CourseDetailParams } from '../types/Index';

@Builder
export function CourseDetailPageBuilder() {
  CourseDetailPage()
}

@Component
struct CourseDetailPage {
  @State courseId: number = 0;
  @State courseTitle: string = '';

  aboutToAppear(): void {
    const params = RouterModule.getNavParam<CourseDetailParams>(RouterMap.COURSE_DETAIL_PAGE)
    this.courseId = params?.courseId || 0
    this.courseTitle = params?.courseTitle || ''
    Logger.info('CourseDetailPage', `courseId:${this.courseId}, courseTitle:${this.courseTitle}`)
  }

  build() {
    NavDestination() {
      Column() {
        Text(`${this.courseId}`)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)

        Text(this.courseTitle)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
    }
    .title(this.courseTitle)
  }
}

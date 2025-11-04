import { RouterMap, RouterModule } from 'basic';
import { CourseCard } from '../components/CourseCard';
import { CourseDetailParams, CourseInfo } from '../types/Index';
import { HomePageVM } from '../viewModels/HomePageVM';

@Builder
export function HomePageBuilder() {
  HomePage()
}

@Component
@Entry
struct HomePage {
  vm: HomePageVM = HomePageVM.instance

  aboutToAppear(): void {
    this.vm.getCourseList()
  }

  build() {
    Scroll() {
      Column() {
        Grid() {
          ForEach(this.vm.courseList, (item: CourseInfo, index: number) => {
            GridItem() {
              CourseCard({
                courseInfo: item,
                jumpCourseDetail: () => {
                  RouterModule.push(RouterMap.COURSE_DETAIL_PAGE, {
                    courseId: item.id,
                    courseTitle: item.title
                  } as CourseDetailParams)
                }
              })
            }
          }, (item: CourseInfo) => item.id.toString())
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(8)
        .rowsGap(8)
        .width('100%')
        .padding(16)
      }
    }
    .width('100%')
    .height('100%')
  }
}

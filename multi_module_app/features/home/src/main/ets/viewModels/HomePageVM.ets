import { Logger } from 'basic';
import { CourseInfo } from '../types/Index';

@ObservedV2
export class HomePageVM {
  @Trace courseList: CourseInfo[] = []
  private static _instance: HomePageVM;

  public static get instance() {
    if (!HomePageVM._instance) {
      HomePageVM._instance = new HomePageVM();
    }
    return HomePageVM._instance;
  }

  public getCourseList(): void {
    // 生成一组课程数据
    const list: CourseInfo[] = [
      {
        id: 1,
        title: 'Java编程入门',
        instructor: '张老师',
        thumbnail: $r('app.media.course1'),
        rating: 4.5
      },
      {
        id: 2,
        title: 'Python数据分析',
        instructor: '李老师',
        thumbnail: $r('app.media.course2'),
        rating: 4.8
      },
      {
        id: 3,
        title: 'Web前端开发',
        instructor: '王老师',
        thumbnail: $r('app.media.course3'),
        rating: 4.6
      }
    ];
    // 遍历集合
    this.courseList = list.map((item: CourseInfo) => {
      const courseInfo = new CourseInfo();
      courseInfo.id = item.id;
      courseInfo.title = item.title;
      courseInfo.instructor = item.instructor;
      courseInfo.thumbnail = item.thumbnail;
      courseInfo.rating = item.rating;
      return courseInfo;
    });
    Logger.info('HomePageVM', `getCourseList 成功，长度为:${this.courseList.length}`);
  }
}
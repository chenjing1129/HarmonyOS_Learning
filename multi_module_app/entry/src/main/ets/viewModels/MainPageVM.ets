import { CoursePageBuilder } from 'course';
import { HomePageBuilder } from 'home';
import { LearnPageBuilder } from 'learn';
import { ProfilePageBuilder } from 'profile';
import { TabListItem } from '../types/Types';

const TAG: string = 'MainPageVM';

@ObservedV2
export class MainPageVM {
  @Trace curIndex: number = 0;
  public tabList: TabListItem[] = [
    {
      label: '首页',
      icon: $r('app.media.ic_home_default'),
      selectedIcon: $r('app.media.ic_home_selected'),
      component: wrapBuilder(HomePageBuilder),
    },
    {
      label: '课程',
      icon: $r('app.media.ic_course_default'),
      selectedIcon: $r('app.media.ic_course_selected'),
      component: wrapBuilder(CoursePageBuilder),
    },
    {
      label: '学习',
      icon: $r('app.media.ic_learn_default'),
      selectedIcon: $r('app.media.ic_learn_selected'),
      component: wrapBuilder(LearnPageBuilder),
    },
    {
      label: '我的',
      icon: $r('app.media.ic_profile_default'),
      selectedIcon: $r('app.media.ic_profile_selected'),
      component: wrapBuilder(ProfilePageBuilder),
    },
  ];
  private static _instance: MainPageVM;

  public static get instance() {
    if (!MainPageVM._instance) {
      MainPageVM._instance = new MainPageVM();
    }
    return MainPageVM._instance;
  }
}

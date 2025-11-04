import { HomePage } from './HomePage';
import { DiscoverPage } from './DiscoverPage';
import { ProfilePage } from './ProfilePage';

@Entry
@Component
struct MainPage {
  @StorageLink('currentTabIndex') currentIndex: number = 0;

  // Tab 切换事件
  onTabChange(index: number) {
    this.currentIndex = index;
  }

  build() {
    Tabs({ index: this.currentIndex }) {
      // 首页 Tab
      TabContent() {
        HomePage()
      }
      .tabBar(this.TabBuilder(0, '首页', $r('app.media.ic_home')))

      // 发现 Tab
      TabContent() {
        DiscoverPage()
      }
      .tabBar(this.TabBuilder(1, '发现', $r('app.media.ic_discover')))

      // 我的 Tab
      TabContent() {
        ProfilePage()
      }
      .tabBar(this.TabBuilder(2, '我的', $r('app.media.ic_profile')))
    }
    .barPosition(BarPosition.End)
    .onChange((index: number) => this.onTabChange(index))
    .width('100%')
    .height('100%')
    .barMode(BarMode.Fixed)
    .animationDuration(300)
  }

  @Builder
  TabBuilder(index: number, title: string, iconPath: Resource) {
    Column() {
      Image(iconPath)
        .width(24)
        .height(24)
        .fillColor(this.currentIndex === index ? '#007DFF' : '#999')
        .margin({ bottom: 4 })

      Text(title)
        .fontSize(12)
        .fontColor(this.currentIndex === index ? '#007DFF' : '#999')
        .fontWeight(this.currentIndex === index ? FontWeight.Medium : FontWeight.Normal)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding({ top: 8, bottom: 4 })
  }
}

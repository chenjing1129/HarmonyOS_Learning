import { RouterMap, RouterModule } from 'basic';

/**
 * 应用入口页面
 * 作用：初始化Navigation导航栈，并立即跳转到LaunchPage
 */
@Entry
@ComponentV2
struct Index {
  navStack: NavPathStack = RouterModule.getStack();

  aboutToAppear(): void {
    // 立即跳转到启动引导页，避免显示空白
    RouterModule.replace(RouterMap.LAUNCH_PAGE)
  }

  build() {
    Navigation(this.navStack) {
    }
    .hideTitleBar(true)
    .hideNavBar(true)
    .mode(NavigationMode.Stack)
    .backgroundColor(Color.White)
    .height('100%')
    .width('100%');
  }
}
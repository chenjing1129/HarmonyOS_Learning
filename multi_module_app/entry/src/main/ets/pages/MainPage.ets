import { MainPageVM } from '../viewModels/MainPageVM';
import { TabListItem } from '../types/Types';

@Builder
export function MainPageBuilder() {
  MainPage()
}

@Component
struct MainPage {
  vm: MainPageVM = MainPageVM.instance;
  private controller: TabsController = new TabsController();
  callbackFunc: () => void = () => {
    this.controller.changeIndex(1);
  };

  build() {
    NavDestination() {
      Tabs({
        barPosition: BarPosition.End,
        index: this.vm.curIndex,
        controller: this.controller
      }) {
        ForEach(this.vm.tabList, (item: TabListItem, index: number) => {
          TabContent() {
            // 鸿蒙6.0 SDK20中WrappedBuilder需要使用NodeContainer或者通过辅助方法调用
            this.renderTabContent(item)
          }
          .tabBar(this.tabBarBuilder(item, index))
        }, (item: TabListItem) => item.label)
      }
      .scrollable(false)
      .barHeight(56)
      .animationDuration(0)
      .barMode(BarMode.Fixed)
      .barBackgroundColor(Color.White)
      .onChange((index: number) => {
        this.vm.curIndex = index;
      })
    }
    .hideTitleBar(true)
    .backgroundColor(Color.White);
  }

  /**
   * 渲染Tab内容的辅助Builder
   */
  @Builder
  renderTabContent(item: TabListItem) {
    item.component.builder()
  }

  @Builder
  tabBarBuilder(item: TabListItem, index: number) {
    Column() {
      Image(this.vm.curIndex === index ? item.selectedIcon : item.icon)
        .width(24)
        .height(24);
      Text(item.label)
        .fontColor(this.vm.curIndex === index ?
          $r("app.color.primary_blue") : $r("app.color.text_secondary"))
        .fontSize(10)
        .margin({ top: 4 })
    }
    .width('100%')
    .padding({ top: 10 });
  }
}
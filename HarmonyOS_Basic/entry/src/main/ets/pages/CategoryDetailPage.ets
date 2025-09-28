// src/main/ets/pages/CategoryDetailPage.ets
import router from '@ohos.router';

// 定义页面信息接口
interface PageInfo {
  name: string;
  routeName: string;
  description: string;
}

// 定义分类信息接口
interface Category {
  title: string;
  pages: PageInfo[];
}

// 定义路由参数接口
interface CategoryRouteParams {
  category?: string;
}

@Entry
@Component
struct CategoryDetailPage {
  @State category: Category = { title: '', pages: [] };

  aboutToAppear() {
    const params = router.getParams() as CategoryRouteParams;
    if (params && params.category) {
      try {
        this.category = JSON.parse(params.category);
      } catch (e) {
        console.error('Failed to parse category data:', e);
      }
    }
  }

  build() {
    Column() {
      Text(this.category.title)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .padding({ top: 40, bottom: 20, left: 20, right: 20 })
        .width('100%')
        .textAlign(TextAlign.Start)

      List() {
        ForEach(this.category.pages, (page: PageInfo) => {
          ListItem() {
            NavItem({ page: page })
          }
        })
      }
      .layoutWeight(1)
      .width('100%')
      .padding({ left: 10, right: 10 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}

// 导航项组件
@Component
struct NavItem {
  @Prop page: PageInfo;

  build() {
    Row() {
      Column() {
        Text(this.page.name)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
        Text(this.page.description)
          .fontSize(14)
          .fontColor(Color.Gray)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Text('>')
        .fontSize(24)
        .fontColor(Color.Gray)
    }
    .padding(15)
    .borderRadius(10)
    .backgroundColor(Color.White)
    .onClick(() => {
      try {
        router.pushUrl({ url: this.page.routeName });
      } catch (err) {
        console.error(`Failed to push to url: ${this.page.routeName}. Code: ${err.code}, message: ${err.message}`);
      }
    })
  }
} 
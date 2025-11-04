// src/main/ets/pages/HomePage.ets
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

@Entry
@Component
struct HomePage {
  // 定义所有页面和分类
  private categories: Category[] = [
    {
      title: '网络请求示例',
      pages: [
        { name: '玩安卓API', routeName: 'pages/WanAndroidPage', description: '使用HttpRequest获取玩安卓开放API数据' }
      ]
    },
    {
      title: '基础组件',
      pages: [
        { name: 'Text', routeName: 'pages/basic/TextExamplePage', description: 'Text组件示例' },
        { name: 'TextInput', routeName: 'pages/basic/TextInputExamplePage', description: 'TextInput组件示例' },
        { name: 'Button', routeName: 'pages/basic/ButtonExamplePage', description: 'Button组件示例' },
        { name: 'Image', routeName: 'pages/basic/ImageExamplePage', description: 'Image组件示例' },
        { name: 'List', routeName: 'pages/basic/ListExamplePage', description: 'List组件示例' },
      ]
    },
    {
      title: '布局',
      pages: [
        { name: '线性布局', routeName: 'pages/layout/OneDimensionalPage', description: 'Row和Column组件示例' }
      ]
    },
    {
      title: '动画',
      pages: [
        { name: '显示动画', routeName: 'pages/animation/ExplictAnimationPage', description: 'Explicit Animation' },
        { name: '关键帧动画', routeName: 'pages/animation/KeyframeAnimationPage', description: 'Keyframe Animation' }
      ]
    },
    {
      title: '完整页面',
      pages: [
        { name: '登录页面', routeName: 'pages/full_pages/LoginPage', description: 'Login Page Example' },
        { name: '商品列表页面', routeName: 'pages/full_pages/ProductListPage', description: 'Product List Page Example' },
        { name: '个人信息页面', routeName: 'pages/full_pages/ProfilePage', description: 'Profile Page Example' },
        { name: '设置页面', routeName: 'pages/full_pages/SettingsPage', description: 'Settings Page Example' },
        { name: '滑动提示卡片', routeName: 'pages/full_pages/SwipePromptCard', description: 'Swipe Prompt Card Example' }
      ]
    }
  ];

  build() {
    Column() {
      Text('HarmonyOS学习')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .padding({ top: 40, bottom: 20, left: 20, right: 20 })
        .width('100%')
        .textAlign(TextAlign.Start)

      List() {
        ForEach(this.categories, (category: Category) => {
          ListItem() {
            CategoryNavItem({ category: category })
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

// 分类导航项组件
@Component
struct CategoryNavItem {
  @Prop category: Category;

  build() {
    Row() {
      Column() {
        Text(this.category.title)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
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
        router.pushUrl({
          url: 'pages/CategoryDetailPage',
          params: { category: JSON.stringify(this.category) }
        });
      } catch (err) {
        console.error(`Failed to push to url: pages/CategoryDetailPage. Code: ${err.code}, message: ${err.message}`);
      }
    })
  }
} 
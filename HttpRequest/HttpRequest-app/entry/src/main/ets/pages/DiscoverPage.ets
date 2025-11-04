/**
 * 发现页
 */
import { ThemeConstants } from '../common/constants/ThemeConstants'
import { ToastUtil } from '../utils/ToastUtil'

// 发现内容配置
interface DiscoverItem {
  id: number
  title: string
  desc: string
  icon: string
}

@Component
export struct DiscoverPage {
  // 发现内容列表
  private discoverItems: DiscoverItem[] = [
    { id: 1, title: 'API文档', desc: '查看完整的API接口文档', icon: '📖' },
    { id: 2, title: '开发指南', desc: '学习HarmonyOS开发最佳实践', icon: '📚' },
    { id: 3, title: '示例代码', desc: '浏览更多示例代码', icon: '💻' },
    { id: 4, title: '社区交流', desc: '与其他开发者交流经验', icon: '👥' },
    { id: 5, title: '技术博客', desc: '阅读技术文章和教程', icon: '✍️' },
    { id: 6, title: '更新日志', desc: '查看最新的更新内容', icon: '📝' }
  ]

  build() {
    Column() {
      // 顶部标题栏
      this.NavBar()

      // 内容区域
      Scroll() {
        Column({ space: ThemeConstants.SPACE_MD }) {
          // Banner区域
          this.BannerSection()

          // 发现内容网格
          this.DiscoverGrid()
        }
        .padding(ThemeConstants.SPACE_MD)
      }
      .layoutWeight(1)
      .backgroundColor(ThemeConstants.BG_PAGE)
    }
    .width('100%')
    .height('100%')
  }

  /**
   * 导航栏
   */
  @Builder
  NavBar() {
    Row() {
      Text('发现')
        .fontSize(ThemeConstants.FONT_SIZE_LG)
        .fontWeight(FontWeight.Bold)
        .fontColor(ThemeConstants.TEXT_PRIMARY)
    }
    .width('100%')
    .height(ThemeConstants.NAVBAR_HEIGHT)
    .padding({ left: ThemeConstants.SPACE_MD, right: ThemeConstants.SPACE_MD })
    .backgroundColor(ThemeConstants.BG_WHITE)
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Center)
  }

  /**
   * Banner区域
   */
  @Builder
  BannerSection() {
    Column() {
      Text('探索更多')
        .fontSize(ThemeConstants.FONT_SIZE_MD + 2)
        .fontWeight(FontWeight.Bold)
        .fontColor(ThemeConstants.TEXT_WHITE)
        .margin({ bottom: ThemeConstants.SPACE_XS })

      Text('发现HarmonyOS的更多可能')
        .fontSize(ThemeConstants.FONT_SIZE_XS)
        .fontColor(ThemeConstants.TEXT_WHITE)
        .opacity(0.9)
    }
    .width('100%')
    .height(160)
    .padding(ThemeConstants.SPACE_LG)
    .backgroundColor(ThemeConstants.PRIMARY_COLOR)
    .borderRadius(ThemeConstants.BORDER_RADIUS_MD)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
  }

  /**
   * 发现内容网格
   */
  @Builder
  DiscoverGrid() {
    Grid() {
      ForEach(this.discoverItems, (item: DiscoverItem) => {
        GridItem() {
          this.DiscoverCard(item)
        }
      })
    }
    .columnsTemplate('1fr 1fr')
    .rowsGap(ThemeConstants.SPACE_SM)
    .columnsGap(ThemeConstants.SPACE_SM)
    .width('100%')
    .height(450)
  }

  /**
   * 发现卡片
   */
  @Builder
  DiscoverCard(item: DiscoverItem) {
    Column({ space: ThemeConstants.SPACE_SM }) {
      Text(item.icon)
        .fontSize(36)

      Text(item.title)
        .fontSize(ThemeConstants.FONT_SIZE_BASE)
        .fontWeight(FontWeight.Medium)
        .fontColor(ThemeConstants.TEXT_PRIMARY)

      Text(item.desc)
        .fontSize(ThemeConstants.FONT_SIZE_XXS)
        .fontColor(ThemeConstants.TEXT_TERTIARY)
        .textAlign(TextAlign.Center)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height(140)
    .padding(ThemeConstants.SPACE_MD)
    .backgroundColor(ThemeConstants.BG_WHITE)
    .borderRadius(ThemeConstants.BORDER_RADIUS_MD)
    .justifyContent(FlexAlign.Center)
    .shadow(ThemeConstants.SHADOW_NORMAL)
    .onClick(() => {
      ToastUtil.info(`点击了: ${item.title}`)
    })
  }
}

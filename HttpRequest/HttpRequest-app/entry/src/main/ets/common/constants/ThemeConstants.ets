/**
 * 主题样式常量
 * 统一管理应用的颜色、字体、间距等样式
 */

export class ThemeConstants {
  // 主色调
  static readonly PRIMARY_COLOR = '#007DFF'
  static readonly PRIMARY_LIGHT_COLOR = '#E6F2FF'
  static readonly SUCCESS_COLOR = '#52C41A'
  static readonly WARNING_COLOR = '#FF9500'
  static readonly DANGER_COLOR = '#FF3B30'
  static readonly INFO_COLOR = '#909399'
  
  // 文本颜色
  static readonly TEXT_PRIMARY = '#333333'
  static readonly TEXT_SECONDARY = '#666666'
  static readonly TEXT_TERTIARY = '#999999'
  static readonly TEXT_PLACEHOLDER = '#CCCCCC'
  static readonly TEXT_WHITE = '#FFFFFF'
  
  // 背景颜色
  static readonly BG_PAGE = '#F5F5F5'
  static readonly BG_WHITE = '#FFFFFF'
  static readonly BG_GRAY = '#F5F5F5'
  static readonly BG_LIGHT_GRAY = '#FAFAFA'
  static readonly BG_DISABLED = '#F0F0F0'
  
  // 边框颜色
  static readonly BORDER_COLOR = '#E0E0E0'
  static readonly DIVIDER_COLOR = '#F0F0F0'
  
  // 字体大小
  static readonly FONT_SIZE_XL = 24
  static readonly FONT_SIZE_LG = 20
  static readonly FONT_SIZE_MD = 18
  static readonly FONT_SIZE_BASE = 16
  static readonly FONT_SIZE_SM = 15
  static readonly FONT_SIZE_XS = 14
  static readonly FONT_SIZE_XXS = 12
  
  // 圆角
  static readonly BORDER_RADIUS_XL = 24
  static readonly BORDER_RADIUS_LG = 16
  static readonly BORDER_RADIUS_MD = 12
  static readonly BORDER_RADIUS_SM = 8
  static readonly BORDER_RADIUS_XS = 4
  static readonly BORDER_RADIUS_CIRCLE = 999
  
  // 间距
  static readonly SPACE_XL = 32
  static readonly SPACE_LG = 24
  static readonly SPACE_MD = 16
  static readonly SPACE_SM = 12
  static readonly SPACE_XS = 8
  static readonly SPACE_XXS = 4
  
  // 组件尺寸
  static readonly BUTTON_HEIGHT = 48
  static readonly INPUT_HEIGHT = 48
  static readonly NAVBAR_HEIGHT = 56
  static readonly TABBAR_HEIGHT = 60
  static readonly ICON_SIZE_LG = 80
  static readonly ICON_SIZE_MD = 40
  static readonly ICON_SIZE_SM = 24
  
  // 阴影配置
  static readonly SHADOW_LIGHT: ShadowOptions = {
    radius: 4,
    color: '#0D000000',
    offsetX: 0,
    offsetY: 2
  }
  
  static readonly SHADOW_NORMAL: ShadowOptions = {
    radius: 8,
    color: '#1F000000',
    offsetX: 0,
    offsetY: 2
  }
  
  static readonly SHADOW_HEAVY: ShadowOptions = {
    radius: 16,
    color: '#33000000',
    offsetX: 0,
    offsetY: 4
  }
}


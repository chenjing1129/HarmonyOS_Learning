/**
 * ProductInfo.ets
 * 简要描述：商品信息数据模型
 * 作者：cj
 * 日期：2025/9/9
 */
export interface ProductInfo {
  id: number          // 商品id，唯一标识
  name: string        // 商品名称
  price: number       // 商品价格
  originalPrice?: number  // 原价，可选
  image: Resource     // 商品图片
  description?: string    // 商品描述，可选
  category: string    // 商品分类
  stock: number       // 库存数量
  isOnSale: boolean   // 是否促销
  rating?: number     // 评分，可选
  salesCount?: number // 销量，可选
}
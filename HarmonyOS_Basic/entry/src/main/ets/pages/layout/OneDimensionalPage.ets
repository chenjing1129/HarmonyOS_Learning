import { ColumnDemo } from '../../components/layout/ColumnDemo'
import { FlexDemo } from '../../components/layout/FlexDemo'
import { GridDemo } from '../../components/layout/GridDemo'
import { RowDemo } from '../../components/layout/RowDemo'
import { StackDemo } from '../../components/layout/StackDemo'

@Entry
@Component
struct OneDimensionalPage {
  build() {
    Column({space: 8}) {
      // RowDemo()
      // ColumnDemo()
      // FlexDemo()
      GridDemo()
      StackDemo()
    }
    .width('100%')
    .height('100%')
  }
}
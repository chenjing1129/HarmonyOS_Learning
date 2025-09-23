import { ColumnDemo } from '../components/ColumnDemo'
import { FlexDemo } from '../components/FlexDemo'
import { GridDemo } from '../components/GridDemo'
import { RowDemo } from '../components/RowDemo'
import { StackDemo } from '../components/StackDemo'

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
import { ProfileCard } from '../components/ProfileCard';
import { ProfileData } from '../viewmodel/ProfileData';

@Entry
@Component
struct ProfilePage {
  @State profileData: ProfileData = new ProfileData(
    "HarmonyOS开发者",
    $r('app.media.avatar'),
    "这是个例子。"
  );

  build() {
    Column() {
      ProfileCard({ profile: this.profileData })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#f1f3f5')
  }
} 
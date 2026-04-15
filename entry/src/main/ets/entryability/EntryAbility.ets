import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { Path_Splash } from '../pages/SplashPage';
import PreferenceUtil from '../util/PreferencesUtil';
import { BusinessError } from '@kit.BasicServicesKit';
import { Path_Main } from '../pages/MainPage';
import DbUtil from '../util/DbUtil';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
  }

  onDestroy(): void {
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    let windowClass: window.Window = windowStage.getMainWindowSync();
    let isLayoutFullScreen = true;
    windowClass.setWindowLayoutFullScreen(isLayoutFullScreen)
      .then(() => {
      })
      .catch((err: BusinessError) => {
      });

    windowStage.loadContent(Path_Splash, (err) => {
      if (err.code) {
        return;
      }
    });

    PreferenceUtil.init(this.context)
    DbUtil.init(this.context)
  }

  onWindowStageDestroy(): void {
  }

  onForeground(): void {
  }

  onBackground(): void {
  }
}

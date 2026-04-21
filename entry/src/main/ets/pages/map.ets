import webview from '@ohos.web.webview'
import { router } from '@kit.ArkUI'

@Entry
@Component
export struct map {
  private webviewController: webview.WebviewController = new webview.WebviewController()
  @State isLoaded: boolean = false

  build() {
    Column() {
      // 地图WebView（占据全屏，H5负责顶部面板和工具栏）
      Web({
        src: $rawfile('map.html'),
        controller: this.webviewController
      })
        .width('100%')
        .layoutWeight(1)
        .javaScriptAccess(true)
        .geolocationAccess(true)
        .domStorageAccess(true)
        .databaseAccess(true)
        .cacheMode(CacheMode.Default)
        .textZoomRatio(100)
        .onPageEnd(() => {
          this.isLoaded = true
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

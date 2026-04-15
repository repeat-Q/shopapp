import { promptAction, router } from "@kit.ArkUI";
import MyData from "../../modle/MyData";
import { emitter } from "@kit.BasicServicesKit";
import GlobalState from "../../util/GlobalState";

interface BalanceUpdateEventData {
  paymentAmount: number;
}

interface GeneratedTypeLiteralInterface_3 {
  data: BalanceUpdateEventData;
}

@Entry
@Component
export struct HomeFragment {
  @State message: string = 'Hello World';
  @State userBalance: number = 2350;

  toast(s: string) {
    promptAction.showToast({
      message: s,
      duration: 1000,
      bottom: '360vp'
    })
  }

  aboutToAppear(): void {
    // 每次页面显示时都重新加载余额
    this.loadUserBalance();
    
    // 监听余额更新事件
    emitter.on({ eventId: 3 }, (event: GeneratedTypeLiteralInterface_3) => {
      // 直接更新UI
      this.userBalance = this.userBalance - event.data.paymentAmount;
    });
  }

  aboutToDisappear() {
    // 移除事件监听
    emitter.off(3);
  }

  // 加载用户余额
  async loadUserBalance(): Promise<void> {
    try {
      this.userBalance = GlobalState.getBalance();
    } catch (error) {
    }
  }

  build() {
    Scroll() {
      Column() {
        Blank().height(50)

        // ========== 顶部用户卡片 ==========
      Row() {
        Row() {
          Stack() {
            Stack().width(65).height(65)
              .borderRadius(32.5)
              .backgroundColor(Color.White)
            Image($r('app.media.chun01'))
              .width(60)
              .width(60)
              .borderRadius(30)
          }.alignContent(Alignment.Center)

          Column({ space: 5 }) {
            Text('Hi,你好')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333')
            Text(`余额：${this.userBalance}`)
              .fontSize(14)
              .fontColor('#EB5E1A')
            Text('积分：320')
              .fontSize(14)
              .fontColor('#666')
          }
          .margin({ left: 20 }).alignItems(HorizontalAlign.Start)
        }
      }
      .borderRadius(16)
      .backgroundColor(Color.White)
      .width('95%')
      .padding(15)
      .margin({ top: 10 })
      .shadow({ radius: 8, color: '#1AEB5E1A', offsetX: 0, offsetY: 2 })

      // ========== 轮播图 ==========
      Swiper() {
        Image($r('app.media.chi01'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
        Image($r('app.media.chi02'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
        Image($r('app.media.chi03'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
      }
      .margin({ left: 16, right: 16, top: 15 })
      .borderRadius(12)
      .aspectRatio(2.2)
      .loop(true)
      .autoPlay(true)
      .interval(3000)
      .vertical(false)
      .indicator(
        Indicator.dot()
          .itemWidth(6)
          .itemHeight(6)
          .color('rgba(255,255,255,0.5)')
          .selectedItemWidth(12)
          .selectedItemHeight(6)
          .selectedColor('#EB5E1A')
          .bottom(8)
      )

      // ========== 快捷功能入口 ==========
      Row() {
        Column() {
          Image($r('app.media.tangshi'))
            .formLogoStyle()
          Text('美团外卖')
            .fontSize(13)
            .fontColor('#333')
        }.onClick(() => {
          router.pushUrl({ url: 'pages/meituan' });
        })

        Column() {
          Image($r('app.media.dao888'))
            .formLogoStyle()
          Text('导航')
            .fontSize(13)
            .fontColor('#333')
        }
        .onClick(() => {
          router.pushUrl({ url: 'pages/map' });
        })

        Column() {
          Image($r('app.media.qianbao'))
            .formLogoStyle()
          Text('支付方式')
            .fontSize(13)
            .fontColor('#333')
        }.onClick(() => {
          this.toast('支付方式')
        })

        Column() {
          Image($r('app.media.qiandaizi'))
            .formLogoStyle()
          Text('会员充值')
            .fontSize(13)
            .fontColor('#333')
        }.onClick(() => {
          this.toast('会员充值')
        })
      }
      .borderRadius(12)
      .height(90)
      .width('95%')
      .margin({ top: 12 })
      .justifyContent(FlexAlign.SpaceEvenly)
      .padding({ top: 12, bottom: 12 })
      .backgroundColor(Color.White)
      .shadow({ radius: 6, color: '#1AEB5E1A', offsetX: 0, offsetY: 2 })

      // ========== 福利专区 ==========
      Row() {
        Column() {
          Image($r('app.media.liwu'))
            .formLogoStyle2()
          Text('天天福利')
            .fontSize(13)
            .fontColor('#333')
        }.onClick(() => {
          this.toast('天天福利')
        })

        Column() {
          Image($r('app.media.kaquan'))
            .formLogoStyle2()
          Text('我的卡券')
            .fontSize(13)
            .fontColor('#333')
        }.onClick(() => {
          this.toast('我的卡券')
        })
      }
      .borderRadius(12)
      .height(80)
      .width('95%')
      .margin({ top: 10 })
      .justifyContent(FlexAlign.SpaceEvenly)
      .padding({ top: 10, bottom: 10 })
      .backgroundColor(Color.White)
      .shadow({ radius: 6, color: '#1AEB5E1A', offsetX: 0, offsetY: 2 })

      // ========== 热门推荐 ==========
      Text('热门推荐')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333')
        .margin({ top: 15, left: 16, bottom: 10 })
        .width('100%')

      Row({space: 10}){
        Column() {
          Image($r('app.media.hanbao'))
            .width('100%')
            .height(80)
            .borderRadius({ topLeft: 12, topRight: 12 })
            .objectFit(ImageFit.Cover)
          Text('汉堡套餐')
            .fontSize(14)
            .fontColor('#333')
            .margin({ top: 8 })
          Text('￥28.8')
            .fontSize(14)
            .fontColor('#EB5E1A')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .borderRadius(12)
        .backgroundColor(Color.White)
        .padding(10)
        .shadow({ radius: 4, color: '#1AEB5E1A', offsetX: 0, offsetY: 2 })

        Column() {
          Image($r('app.media.xican2'))
            .width('100%')
            .height(80)
            .borderRadius({ topLeft: 12, topRight: 12 })
            .objectFit(ImageFit.Cover)
          Text('精致西餐')
            .fontSize(14)
            .fontColor('#333')
            .margin({ top: 8 })
          Text('￥58.8')
            .fontSize(14)
            .fontColor('#EB5E1A')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .borderRadius(12)
        .backgroundColor(Color.White)
        .padding(10)
        .shadow({ radius: 4, color: '#1AEB5E1A', offsetX: 0, offsetY: 2 })
      }
      .padding({ left: 16, right: 16 })
      .margin({ bottom: 20 })

      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')

    }
    .width('100%')
    .height('100%')
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Auto)
    .edgeEffect(EdgeEffect.Spring)
    .constraintSize({ maxHeight: '100%' })
  }
}

@Styles
function formSwiperStyle() {
  .height(300)
  .width('100%')
}

@Styles
function formLogoStyle() {
  .width(36)
  .height(28)
  .margin({ bottom: 6 })
}

@Styles
function formLogoStyle2() {
  .width(32)
  .height(24)
  .margin({ bottom: 6 })
}

import router from '@ohos.router';
import { emitter } from '@kit.BasicServicesKit';
import GlobalState from '../util/GlobalState';

// 定义余额更新事件数据类型
interface BalanceUpdateEventData {
  paymentAmount: number;
}

interface BalanceUpdateEvent {
  data: BalanceUpdateEventData;
}

// 定义菜单项接口
interface MenuItem {
  title: string;
  icon: Resource;
  arrow?: boolean;
}

@Entry
@Component
export struct geren {
  @State avatar: Resource = $r('app.media.chun01');
  @State studentId: string = '1120231734';
  @State hobbies: string[] = ['编程', '阅读', '运动', '音乐'];
  @State gender: string = '男';
  @State motto: string = '天道酬勤，厚德载物';
  @State username: string = '咖啡爱好者';
  @State balance: number = 2350;
  @State points: string = '320';

  // 菜单项数据
  private menuItems: MenuItem[] = [
    { title: '我的订单', icon: $r('app.media.qianbao'), arrow: true },
    { title: '收货地址', icon: $r('app.media.dao888'), arrow: true },
    { title: '优惠券', icon: $r('app.media.kaquan'), arrow: true },
    { title: '会员中心', icon: $r('app.media.qiandaizi'), arrow: true },
    { title: '帮助中心', icon: $r('app.media.liwu'), arrow: true },
    { title: '设置', icon: $r('app.media.dao888'), arrow: true },
  ];

  aboutToAppear(): void {
    // 每次页面显示时都重新加载余额
    this.loadUserBalance();
    
    // 监听余额更新事件
    emitter.on({ eventId: 3 }, (event: BalanceUpdateEvent) => {
      // 直接更新UI
      this.balance = this.balance - event.data.paymentAmount;
    });
  }

  aboutToDisappear() {
    // 移除事件监听
    emitter.off(3);
  }

  // 加载用户余额
  async loadUserBalance(): Promise<void> {
    try {
      this.balance = GlobalState.getBalance();
    } catch (error) {
    }
  }

  build() {
    Scroll() {
      Column() {
        // ========== 顶部个人信息卡片 ==========
      Column() {
        // 头像
        Image(this.avatar)
          .width(80)
          .height(80)
          .borderRadius(40)
          .border({ width: 3, color: '#EB5E1A' })
          .margin({ top: 20 })

        // 用户名
        Text(this.username)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')
          .margin({ top: 12 })

        // 学号信息
        Text(`学号：${this.studentId}`)
          .fontSize(14)
          .fontColor('#666')
          .margin({ top: 4 })

        // 余额和积分
        Row({ space: 40 }) {
          Column() {
            Text('余额')
              .fontSize(12)
              .fontColor('#999')
            Text(`￥${this.balance.toFixed(2)}`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#EB5E1A')
              .margin({ top: 4 })
          }

          Column() {
            Text('积分')
              .fontSize(12)
              .fontColor('#999')
            Text(this.points)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#EB5E1A')
              .margin({ top: 4 })
          }
        }
        .margin({ top: 15 })
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius({ bottomLeft: 24, bottomRight: 24 })
      .shadow({ radius: 10, color: '#1AEB5E1A', offsetX: 0, offsetY: 4 })

      // ========== 爱好标签 ==========
      Column() {
        Row() {
          Text('我的爱好')
            .fontSize(14)
            .fontColor('#999')
            .margin({ right: 10 })
        }
        .width('90%')
        .margin({ top: 15, bottom: 10 })

        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.hobbies, (hobby: string) => {
            Text(hobby)
              .fontSize(14)
              .fontColor('#EB5E1A')
              .backgroundColor('#FFF0E8')
              .borderRadius(16)
              .padding({ left: 14, right: 14, top: 6, bottom: 6 })
              .margin({ right: 10, bottom: 8 })
          })
        }
        .width('90%')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)

      // ========== 格言卡片 ==========
      Column() {
        Text('人生格言')
          .fontSize(14)
          .fontColor('#999')
          .margin({ bottom: 8 })
        Text(this.motto)
          .fontSize(16)
          .fontStyle(FontStyle.Italic)
          .textAlign(TextAlign.Center)
          .fontColor('#555')
      }
      .width('90%')
      .padding(16)
      .backgroundColor(Color.White)
      .borderRadius(12)
      .border({ width: 1, color: '#EB5E1A', radius: 12 })
      .margin({ top: 10 })

      // ========== 菜单列表 ==========
      Column() {
        List() {
          ForEach(this.menuItems, (item: MenuItem, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Image(item.icon)
                    .width(24)
                    .height(24)
                    .margin({ right: 12 })

                  Text(item.title)
                    .fontSize(15)
                    .fontColor('#333')
                    .layoutWeight(1)

                  if (item.arrow) {
                    Image($r('app.media.dao888'))
                      .width(16)
                      .height(16)
                      .rotate({ angle: 90 })
                      .opacity(0.4)
                  }
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 14, bottom: 14 })
                
                // 分隔线（如果不是最后一项）
                if (index < this.menuItems.length - 1) {
                  Divider()
                    .color('#F0F0F0')
                    .margin({ left: 52 })
                }
              }
            }
            .onClick(() => {
              // 菜单项点击处理
            })
          })
        }
        .width('100%')
        .backgroundColor(Color.White)
        .borderRadius(12)
      }
      .width('90%')
      .margin({ top: 15 })
      .shadow({ radius: 6, color: '#1AEB5E1A', offsetX: 0, offsetY: 2 })

      // ========== 退出登录按钮 ==========
      Button('退出登录', { type: ButtonType.Capsule })
        .width('80%')
        .height(48)
        .fontSize(16)
        .fontColor('#EB5E1A')
        .backgroundColor('#FFF0E8')
        .margin({ top: 25, bottom: 30 })
        .onClick(() => {
          router.replaceUrl({ url: 'pages/LoginPage' });
        })

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

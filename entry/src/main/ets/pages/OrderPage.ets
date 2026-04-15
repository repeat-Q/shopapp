import { promptAction } from '@kit.ArkUI';
import { router } from '@kit.ArkUI';
import Food from '../modle/Food';
import MyData from '../modle/MyData';
import DbUtil from '../util/DbUtil';
import { emitter } from '@kit.BasicServicesKit';
import { Order, OrderItem } from '../modle/Order';

interface GeneratedTypeLiteralInterface_2 {
  eatType: string;
}

interface GeneratedTypeLiteralInterface_1 {
  data: GeneratedTypeLiteralInterface_2;
}

// 定义一个简单的订单接口用于创建新对象
interface SimpleOrder {
  orderId: string;
  items: OrderItem[];
  totalPrice: number;
  eatType: string;
  createTime: string;
}

@Entry
@Component
export struct OrderPage {
  @State orders: Order[] = [];
  @State currentOrder: Order | null = null;
  @State selectedOrderId: string = '';
  @State eatType: string = '堂食';

  aboutToAppear() {
    // 监听用餐方式更新事件
    emitter.on({ eventId: 1 }, (event: GeneratedTypeLiteralInterface_1) => {
      this.eatType = event.data.eatType;
    });
    
    // 监听订单更新事件 - 购物车结算后触发
    emitter.on({ eventId: 4 }, () => {
      console.log('收到订单更新事件，重新加载订单数据');
      this.loadOrders();
    });

    // 初始化加载订单数据
    this.loadOrders();
  }

  aboutToDisappear() {
    // 移除事件监听
    emitter.off(1);
    emitter.off(4);
  }

  async loadOrders() {
    try {
      console.log('开始加载订单数据...');
      // 只获取最近5个订单
      this.orders = await DbUtil.queryRecentOrders(5);
      console.log(`成功加载 ${this.orders.length} 个订单`);
      
      // 初始状态不选中任何订单，等待用户点击
      this.currentOrder = null;
      this.selectedOrderId = '';
      
      // 调试信息
      if (this.orders.length > 0) {
        console.log(`加载了 ${this.orders.length} 个订单`);
      }
    } catch (error) {
      console.error('加载订单失败:', error);
    }
  }

  // 获取当前选中的订单
  getSelectedOrder(): Order | null {
    if (!this.selectedOrderId || this.orders.length === 0) {
      return null;
    }
    return this.orders.find(order => order.orderId === this.selectedOrderId) || null;
  }

  build() {
    Scroll() {
      Column() {
        // 始终显示订单列表区域（如果有订单）
        if (this.orders.length > 0) {
          this.orderListView()
        } else {
          // 没有订单时显示空状态
          this.emptyView()
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#f1f3f5')
    }
    .width('100%')
    .height('100%')
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Auto)
    .edgeEffect(EdgeEffect.Spring)
    .constraintSize({ maxHeight: '100%' })
  }

  @Builder
  orderListView() {
    Column() {
      // 最近订单标题
      Row() {
        Text('最近订单')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')
        Blank()
        Text(`共${this.orders.length}个订单`)
          .fontSize(14)
          .fontColor('#666')
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 10, bottom: 10 })
      .backgroundColor(Color.White)

      // 订单列表
      if (this.orders.length > 0) {
        List({ space: 8 }) {
          ForEach(this.orders, (order: Order, index: number) => {
            ListItem() {
              this.orderItem(order, index + 1)
            }
            .onClick(() => {
              console.log(`点击了订单: ${order.orderId}, 当前选中的订单ID: ${this.selectedOrderId}`);
              
              // 如果点击的是当前选中的订单，则取消选中
              if (this.selectedOrderId === order.orderId) {
                this.selectedOrderId = '';
                this.currentOrder = null;
                console.log(`取消选中订单: ${order.orderId}`);
              } else {
                // 否则选中这个订单
                this.selectedOrderId = order.orderId;
                this.currentOrder = order;
                console.log(`选中订单: ${order.orderId}`);
              }
            })
          })
        }
        .width('100%')
        .height(280)
        .padding({ left: 16, right: 16 })
        .layoutWeight(1)
      } else {
        Column() {
          Image($r('app.media.ic_empty'))
            .width(100)
            .height(100)
            .margin({ bottom: 16 })
          Text('暂无订单记录')
            .fontSize(16)
            .fontColor('#999')
        }
        .width('100%')
        .height(200)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }

      // 订单详情区域
      if (this.getSelectedOrder()) {
        // 显示选中的订单详情
        this.orderDetailView(this.getSelectedOrder()!)
      } else if (this.orders.length > 0) {
        // 有订单但未选中任何订单，显示提示
        this.noOrderSelectedView()
      } else {
        // 无订单数据，显示空状态
        this.emptyView()
      }
    }
  }

  @Builder
  orderItem(order: Order, index: number) {
    Column() {
      Row() {
        // 订单序号 - 橙色圆形
        Column() {
          Text(`${index}`)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#EB5E1A')
        }
        .width(24)
        .height(24)
        .backgroundColor('#FFF0E8')
        .borderRadius(12)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .margin({ right: 12 })

        Column({ space: 4 }) {
          // 订单号和金额
          Row() {
            Text(`订单号: ${order.orderId.substring(0, 8)}...`)
              .fontSize(14)
              .fontColor('#333')
              .fontWeight(FontWeight.Medium)
            Blank()
            Text(`￥${order.totalPrice.toFixed(2)}`)
              .fontSize(16)
              .fontColor('#EB5E1A')
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')

          // 用餐方式和日期
          Row() {
            Text(order.eatType)
              .fontSize(12)
              .fontColor('#666')
            Blank()
            Text(new Date(order.createTime || '').toLocaleDateString())
              .fontSize(12)
              .fontColor('#999')
          }
          .width('100%')
        }
        .layoutWeight(1)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    }
    .width('100%')
    .backgroundColor(this.selectedOrderId === order.orderId ? '#F0F9FF' : Color.White)
    .borderRadius(8)
    .border({
      width: 1,
      color: this.selectedOrderId === order.orderId ? '#1890FF' : '#F0F0F0',
      style: BorderStyle.Solid
    })
    .margin({ bottom: 8 })
  }

  @Builder
  orderDetailView(order: Order) {
    Column() {
      // 订单详情标题
      Row() {
        Text('订单详情')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')
        Blank()
        Text('点击切换')
          .fontSize(12)
          .fontColor('#1890FF')
      }
      .width('100%')
      .padding({ bottom: 16 })

      // 订单基本信息卡片
      Column({ space: 12 }) {
        // 订单号
        Row() {
          Text('订单号:')
            .fontSize(14)
            .fontColor('#666')
            .width(70)
          Text(order.orderId)
            .fontSize(14)
            .fontColor('#333')
            .layoutWeight(1)
        }
        .width('100%')

        // 下单时间
        Row() {
          Text('下单时间:')
            .fontSize(14)
            .fontColor('#666')
            .width(70)
          Text(new Date(order.createTime || '').toLocaleString())
            .fontSize(14)
            .fontColor('#333')
            .layoutWeight(1)
        }
        .width('100%')

        // 用餐方式
        Row() {
          Text('用餐方式:')
            .fontSize(14)
            .fontColor('#666')
            .width(70)
          Text(order.eatType)
            .fontSize(14)
            .fontColor('#333')
            .layoutWeight(1)
        }
        .width('100%')
      }
      .width('100%')
      .padding(16)
      .backgroundColor(Color.White)
      .borderRadius(8)
      .margin({ bottom: 16 })

      // 商品列表标题
      Text('商品清单')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333')
        .margin({ bottom: 12 })

      // 商品列表
      if (order.items && order.items.length > 0) {
        Column({ space: 8 }) {
          ForEach(order.items, (item: Food, index: number) => {
            this.orderDetailItem(item)
          })
        }
        .width('100%')
        .margin({ bottom: 16 })
      } else {
        Column() {
          Text('暂无商品信息')
            .fontSize(14)
            .fontColor('#999')
        }
        .width('100%')
        .height(80)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ bottom: 16 })
      }

      // 合计金额
      Row() {
        Text('合计金额:')
          .fontSize(16)
          .fontColor('#333')
          .fontWeight(FontWeight.Medium)
        Blank()
        Text(`￥${order.totalPrice.toFixed(2)}`)
          .fontSize(20)
          .fontColor('#EB5E1A')
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding({ top: 16, bottom: 8 })
      .border({ width: { top: 1 }, color: { top: '#F0F0F0' }, style: { top: BorderStyle.Solid } })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ top: 10, left: 16, right: 16, bottom: 20 })
    .border({
      width: 1,
      color: '#F0F0F0',
      style: BorderStyle.Solid
    })
    .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
  }

  @Builder
  orderDetailItem(item: Food) {
    Row() {
      // 商品图片
      Image(MyData.getImgRes(item.icon_id))
        .width(60)
        .height(60)
        .borderRadius(8)
        .margin({ right: 12 })

      Column({ space: 4 }) {
        // 商品名称
        Text(item.name)
          .fontSize(16)
          .fontColor('#333')
          .fontWeight(FontWeight.Medium)
        
        // 商品价格
        Text(`￥${item.price.toFixed(2)}`)
          .fontSize(14)
          .fontColor('#EB5E1A')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      // 商品数量（默认为1）
      Text('×1')
        .fontSize(16)
        .fontColor('#666')
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .border({
      width: 1,
      color: '#F0F0F0',
      style: BorderStyle.Solid
    })
    .shadow({ radius: 2, color: '#0A000000', offsetX: 0, offsetY: 1 })
  }

  @Builder
  noOrderSelectedView() {
    Column() {
      Image($r('app.media.ic_empty'))
        .width(120)
        .height(120)
        .margin({ bottom: 16 })
      Text('点击上方订单查看详情')
        .fontSize(16)
        .fontColor('#999')
        .margin({ bottom: 8 })
      Text('请从上方列表中选择一个订单')
        .fontSize(14)
        .fontColor('#666')
    }
    .width('100%')
    .height(200)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#F8F9FA')
    .borderRadius(12)
    .margin({ top: 10, left: 16, right: 16, bottom: 20 })
    .shadow({ radius: 4, color: '#1A000000', offsetX: 0, offsetY: 2 })
  }

  @Builder
  emptyView() {
    Column() {
      Image($r('app.media.ic_empty'))
        .width(150)
        .height(150)
        .margin({ bottom: 20 })
      Text('暂无订单')
        .fontSize(16)
        .fontColor('#999')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}








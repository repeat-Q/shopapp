import { promptAction } from '@kit.ArkUI';
import { router } from '@kit.ArkUI';
import Food from '../../modle/Food';
import MyData from '../../modle/MyData';
import DbUtil from '../../util/DbUtil';
import { emitter } from '@kit.BasicServicesKit';
import { Order } from '../../modle/Order';
import GlobalState from '../../util/GlobalState';

interface CartItemData {
  item: Food;
  quantity: number;
}

interface GeneratedTypeLiteralInterface_2 {
  eatType: string;
}

interface GeneratedTypeLiteralInterface_1 {
  data: GeneratedTypeLiteralInterface_2;
}

interface BalanceUpdateEventData {
  paymentAmount: number;
}

interface GeneratedTypeLiteralInterface_3 {
  data: BalanceUpdateEventData;
}

@Entry
@Component
export default struct CartFragment {
  @State sumPrice: number = 0;
  @State cartList: CartItemData[] = [];
  @State eatType: string = '堂食';
  @State selectedCount: number = 0;
  @State isAllSelected: boolean = false;

  aboutToAppear() {
    this.loadCartData();
    emitter.on({ eventId: 1 }, (event: GeneratedTypeLiteralInterface_1) => {
      this.eatType = event.data.eatType;
    });
    // 监听购物车更新事件
    emitter.on({ eventId: 2 }, () => {
      this.loadCartData().then(() => {
        // 数据加载完成后强制刷新UI
        this.calculatePrice();
      });
    });
  }

  aboutToDisappear() {
    // 移除事件监听
    emitter.off(1);
    emitter.off(2);
    emitter.off(3);
    emitter.off(4);
  }

  // 加载购物车数据
  async loadCartData() {
    try {
      const list = await DbUtil.queryAll();
      // 合并相同商品的数量
      const mergedMap = new Map<string, CartItemData>();
      list.forEach((item: Food) => {
        if (mergedMap.has(item.id_)) {
          mergedMap.get(item.id_)!.quantity += 1;
        } else {
          mergedMap.set(item.id_, { item: item, quantity: 1 });
        }
      });
      this.cartList = Array.from(mergedMap.values());
      this.calculatePrice();
    } catch (error) {
      // 加载失败
    }
  }

  calculatePrice() {
    this.sumPrice = this.cartList.reduce((total, data) => total + data.item.price * data.quantity, 0);
    this.selectedCount = this.cartList.filter(d => d.quantity > 0).length;
  }

  // 增加数量
  increaseQuantity(data: CartItemData) {
    const index = this.cartList.findIndex(d => d.item.id_ === data.item.id_);
    if (index !== -1) {
      this.cartList[index].quantity += 1;
      this.calculatePrice();
    }
  }

  // 减少数量
  decreaseQuantity(data: CartItemData) {
    const index = this.cartList.findIndex(d => d.item.id_ === data.item.id_);
    if (index !== -1) {
      if (this.cartList[index].quantity > 1) {
        this.cartList[index].quantity -= 1;
      } else {
        // 数量为1时删除商品
        DbUtil.delete(data.item.id_);
        this.cartList = this.cartList.filter(d => d.item.id_ !== data.item.id_);
      }
      this.calculatePrice();
    }
  }

  private generateOrderId(): string {
    const now = new Date();
    return `ORD${now.getFullYear()}${(now.getMonth() + 1).toString().padStart(2, '0')}${now.getDate().toString().padStart(2, '0')}${now.getHours().toString().padStart(2, '0')}${now.getMinutes().toString().padStart(2, '0')}${now.getSeconds().toString().padStart(2, '0')}`;
  }

  deleteOne(data: CartItemData) {
    DbUtil.delete(data.item.id_);
    this.cartList = this.cartList.filter(d => d.item.id_ !== data.item.id_);
    this.calculatePrice();
    promptAction.showToast({
      message: '删除成功',
      duration: 1000,
      bottom: '360vp'
    });
  }

  async commitBtn() {
    if (this.sumPrice <= 0) {
      promptAction.showToast({
        message: '请先添加商品',
        duration: 1000,
        bottom: '360vp'
      });
      return;
    }

    // 创建订单商品列表
    const orderItems: Food[] = [];
    this.cartList.forEach(data => {
      for (let i = 0; i < data.quantity; i++) {
        orderItems.push(data.item);
      }
    });

    const order = new Order({
      orderId: this.generateOrderId(),
      items: orderItems,
      totalPrice: this.sumPrice,
      eatType: this.eatType
    });

    try {
      // 1. 使用GlobalState更新余额（它会自动保存到Preferences并发送事件）
      const newBalance = await GlobalState.deductBalance(this.sumPrice);
      
      // 2. 保存订单
      await DbUtil.saveOrder(order);
      
      // 3. 清空购物车
      this.clearCart();
      
      // 4. 发送订单更新事件
      emitter.emit({ eventId: 4 });
      
      // 5. 重置购物车UI状态
      this.sumPrice = 0;
      this.cartList = [];
      
      promptAction.showToast({
        message: '支付成功！请在"订单"tab查看订单详情',
        duration: 3000,
        bottom: '360vp'
      });
    } catch (error) {
      promptAction.showToast({
        message: error.message || '支付失败，请重试',
        duration: 1000,
        bottom: '360vp'
      });
    }
  }

  private clearCart() {
    this.cartList.forEach(data => {
      for (let i = 0; i < data.quantity; i++) {
        DbUtil.delete(data.item.id_);
      }
    });
    this.cartList = [];
    this.calculatePrice();
  }

  build() {
    Scroll() {
      Column() {
        // 顶部留白
        Blank().height(50);

      // 商品列表或空状态
      if (this.cartList.length > 0) {
        List({ space: 12 }) {
          ForEach(this.cartList, (data: CartItemData) => {
            ListItem() {
              this.CartItem(data)
            }
            .swipeAction({ end: this.DeleteBtn(data) })
          })
        }
        .width('100%')
        .padding({ left: 12, right: 12 })
      } else {
        this.EmptyCartView()
      }

      // 底部结算栏
      this.CheckoutBar()
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

  @Builder
  CartItem(data: CartItemData) {
    Row() {
      // 商品图片
      Image(MyData.getImgRes(data.item.icon_id))
        .width(75)
        .height(75)
        .borderRadius(10)
        .margin({ right: 12 })

      // 商品信息
      Column() {
        Text(data.item.name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 4 })
          .width('100%')

        Text(`￥${data.item.price.toFixed(2)}`)
          .fontSize(15)
          .fontColor('#EB5E1A')
          .margin({ bottom: 8 })

        // 数量加减控件
        Row() {
          // 减号按钮
          Text('-')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#EB5E1A')
            .backgroundColor('#FFF0E8')
            .borderRadius(4)
            .width(28)
            .height(28)
            .textAlign(TextAlign.Center)
            .onClick(() => this.decreaseQuantity(data))

          // 数量
          Text(data.quantity.toString())
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333')
            .margin({ left: 12, right: 12 })
            .width(30)
            .textAlign(TextAlign.Center)

          // 加号按钮
          Text('+')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .backgroundColor('#EB5E1A')
            .borderRadius(4)
            .width(28)
            .height(28)
            .textAlign(TextAlign.Center)
            .onClick(() => this.increaseQuantity(data))
        }
        .alignItems(VerticalAlign.Center)
      }
      .width('55%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .shadow({ radius: 4, color: '#1AEB5E1A', offsetX: 0, offsetY: 2 })
  }

  @Builder
  EmptyCartView() {
    Column() {
      Image($r('app.media.ic_empty'))
        .width(150)
        .height(150)
      Text('购物车是空的')
        .fontSize(16)
        .margin({ top: 16 })
        .fontColor('#999')
      Text('快去添加商品吧')
        .fontSize(14)
        .margin({ top: 8 })
        .fontColor('#CCC')
    }
    .width('100%')
    .height('50%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  CheckoutBar() {
    Column() {
      Row() {
        // 统计信息
        Column() {
          Text(`共 ${this.cartList.length} 件商品`)
            .fontSize(13)
            .fontColor('#666')
          Text(`合计：￥${this.sumPrice.toFixed(2)}`)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#EB5E1A')
            .margin({ top: 2 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        // 结算按钮
        Button('去结算', { type: ButtonType.Capsule })
          .width(110)
          .height(40)
          .backgroundColor(this.sumPrice > 0 ? '#EB5E1A' : '#CCCCCC')
          .fontColor(Color.White)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .enabled(this.sumPrice > 0)
          .onClick(() => this.commitBtn())
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .backgroundColor(Color.White)
    .padding({ top: 12, bottom: 12 })
    .shadow({ radius: 8, color: '#1AEB5E1A', offsetX: 0, offsetY: -2 })
  }

  @Builder
  DeleteBtn(data: CartItemData) {
    Column() {
      Image($r('app.media.ic_trash'))
        .width(24)
        .height(24)
      Text('删除')
        .fontSize(14)
        .fontColor(Color.White)
        .margin({ top: 8 })
    }
    .width(80)
    .height('100%')
    .backgroundColor('#FF4D4F')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => this.deleteOne(data))
  }
}

import Food from "../../modle/Food";
import Goods, { Category } from "../../modle/Food";
import MyData from "../../modle/MyData";
import DbUtil from "../../util/DbUtil";
import Toast from "../../util/Toast";
import { emitter } from '@kit.BasicServicesKit';

@Entry
@Component
export struct FoodListFragment {
  @State currCateIndex: number = 0;
  @State currFoodIndex: number = 0;
  @State cateList: Category[] = MyData.categoryList
  @State foodList: Food[] = []
  allFood: Food[] = []
  searchkeyStr: string = ''

  aboutToAppear(): void {
    this.foodList = this.cateList[this.currCateIndex].foodList

    MyData.categoryList.map((cate, cateInd) => {
      cate.foodList.map((food) => {
        this.allFood.push(food)
      })
    })
  }

  onSearchClick() {
    this.foodList = []
    this.allFood.map((food) => {
      if (food.name.indexOf(this.searchkeyStr) >= 0) {
        this.foodList.push(food)
      }
    })
  }

  onCateClick(cateIndex: number) {
    this.currCateIndex = cateIndex
    this.foodList = this.cateList[this.currCateIndex].foodList
  }

  async onAddBtnClick(item: Food) {
    Toast.show('加入成功')
    await DbUtil.insert(item)
    // 发送购物车更新事件
    emitter.emit({ eventId: 2 })
  }

  build() {
    Scroll() {
      Column() {
        Stack() {
        Image($r('app.media.order_top')).height('100%').width('100%')
        Column() {
          Blank().height(50)
          //.backgroundColor($r('app.color.tint_main'))
          Column() {
            Row() {
              Column() {
                Row() {
                  Text($r('app.string.restaurant_name'))
                    .fontWeight(700)
                    .sentenceStyle()
                    .margin({ right: 10 })
                  Text('[切换餐厅]')
                    .fontColor(Color.White)
                    .fontSize(15)
                }

                Row() {
                  Image($r('app.media.map'))
                    .width(15)
                    .margin({ right: 5 })
                    .fillColor(Color.Red)
                  Text('北京东路')
                    .sentenceStyle()
                    .fontSize(15)
                }.margin({ top: 6 })
              }
              .alignItems(HorizontalAlign.Start)

              Row() {
                Text('评价')
                  .sentenceStyle()
                  .fontWeight(700)
              }
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            .padding(10)
          }
          //.backgroundColor($r('app.color.tint_main'))
          .padding({ top: 10, left: 16 })
        }
      }.height(150)

      // 搜索框
      Row() {
        Image($r('app.media.search'))
          .width(21)
          .margin({ left: 16 })

        TextInput({ placeholder: '搜索食物' })
          .textAlign(TextAlign.Start)
          .backgroundColor(Color.Transparent)
          .onChange((value: string, previewText?: PreviewText) => {
            this.searchkeyStr = value
          })
          .layoutWeight(1)

        Text('搜索')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor($r('app.color.main'))
          .margin({ right: 16 })
          .padding({
            left: 14,
            top: 4,
            right: 14,
            bottom: 4
          })
          .borderRadius(13)
          .onClick(() => {
            this.onSearchClick()
          })
      }
      .margin(16)
      .borderRadius(20)
      .backgroundColor($r('app.color.tint_gray'))

      // 商品列表
      Row() {
        // 左侧分类
        Column() {
          Scroll() {
            List() {
              ForEach(this.cateList, (cate: Category, cateIndex: number) => {
                ListItem() {
                  Column() {
                    Image(MyData.getImgRes(cate.logo_id))
                      .width(20)
                      .height(20)
                      .borderRadius(5)
                    Text(cate.name)// 根据实际情况显示数据项的某个属性
                      .fontSize(14)
                      .margin({ top: 5 })
                      .width('100%')
                      .textAlign(TextAlign.Center) // 设置文字横向居中
                  }
                  .height(60)
                  .padding({ top: 6, bottom: 6 })
                  .alignItems(HorizontalAlign.Center)
                  .justifyContent(FlexAlign.Center)
                  .border({
                    width: { left: 5 },
                    color: this.currCateIndex === cateIndex ?
                    $r('app.color.tint_main') : Color.White,
                  })
                  .backgroundColor(this.currCateIndex === cateIndex ?
                  Color.White : $r('app.color.gray_bg'))
                  .onClick(() => {

                    this.onCateClick(cateIndex)
                  })
                }

              });
            }
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBarWidth(5)
          .edgeEffect(EdgeEffect.Fade)
          .scrollBar(BarState.Off)
        }
        .width('25%')
        .height('100%')
        .backgroundColor($r('app.color.gray_bg'))
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
        .margin({ left: 0 })

        // 右侧菜品
        Column() {
          List() {
            ForEach(this.foodList, (item: Food, index: number) => {
              ListItem() {
                Row() {
                  Column() {
                    Image(MyData.getImgRes(item.icon_id))
                      .width(90)
                      .height(90)
                      .borderRadius(10)
                  }

                  Column() {
                    Text(item.name)
                    Text('库存：' + item.stock)
                      .fontSize(12)
                      .fontColor('#ffcac9c9')
                      .margin({ top: 5 })
                    Text("￥ " + item.price)
                      .margin({ top: 5 })
                      .fontColor('#EB5E1A')
                    Row(){
                      Button({ type: ButtonType.Normal, stateEffect: true }) {
                        Row() {
                          Text('加入菜单').fontSize(12).fontColor(0xffffff).margin({ left: 5, right: 5 })
                        }.alignItems(VerticalAlign.Center)
                      }
                      .borderRadius(15)
                      .padding({
                        left: 8,
                        right: 8,
                        top: 5,
                        bottom: 5
                      })
                      .margin({top:5})
                      .backgroundColor($r('app.color.main'))
                      .onClick(() => {
                        this.onAddBtnClick(item)
                      })
                    }
                    .width('100%')
                    .padding({right:30})
                    .justifyContent(FlexAlign.End)
                  }
                  .alignItems(HorizontalAlign.Start)
                  .margin({ left: 10, top: 0 })
                  .layoutWeight(1)
                }

                .width('100%')
                .height(90)
                .margin({ left: 10, top: 10 })
              }
            })
          }
        }
        .width('75%')
        .height('100%')
        .backgroundColor(Color.White)

      }

    }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Start)

    }
    .width('100%')
    .height('100%')
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Auto)
    .edgeEffect(EdgeEffect.Spring)
    .constraintSize({ maxHeight: '100%' })
  }
}

@Extend(Text)
function sentenceStyle() {
  .fontColor(Color.White)
  .fontSize(20)
}

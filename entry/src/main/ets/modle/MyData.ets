import { Category } from './Food'
import { ItemType } from './types'

class MyData {
  imgIdList: number[] = [10, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23,
    30,31,32,33,40,41,42,43,50,51,52,53]
  imgResList: Resource[] = [
    //10
    $r('app.media.xican'),
    $r('app.media.hanbao2'),
    $r('app.media.shala'),
    $r('app.media.pisa'),
    $r('app.media.yidalimian'),
    $r('app.media.xiangchang'),
    $r('app.media.regou'),
    //20
    $r('app.media.chaocai'),
    $r('app.media.shuizhuyu'),
    $r('app.media.malaxianguo'),
    $r('app.media.huiguorou'),
    //30
    $r('app.media.miantiao'),
    $r('app.media.banmian'),
    $r('app.media.daoxiaomian'),
    $r('app.media.xiaomian'),
    //40
    $r('app.media.gaifan'),
    $r('app.media.xihongshi'),
    $r('app.media.tudou'),
    $r('app.media.huiguorougaifan'),
    //50
    $r('app.media.yinliao'),
    $r('app.media.kele'),
    $r('app.media.chengzhi'),
    $r('app.media.lvcha'),
  ]

  getImgRes(imgId: number): Resource {
    let ind = this.imgIdList.indexOf(imgId)
    return this.imgResList[ind]
  }

  mineList: Array<ItemType> = [
    {
      title: '收藏管理',
      img: $r('app.media.ic_shoucang')
    },
    {
      title: '隐私协议',
      img: $r('app.media.ic_privacy')
    },
    {
      title: '热卖推荐',
      img: $r('app.media.ic_tongzhi')
    },
    {
      title: '推送开关',
      img: $r('app.media.ic_data')
    },
    {
      title: '关于我们',
      img: $r('app.media.ic_guanyuwomen')
    },
  ]

  categoryList: Category[] = [
    {
      name: '阿拉比卡咖啡豆',
      logo_id: 10,
      foodList: [
        {
          id_: '11',
          name: '浅烘焙咖啡',
          stock: 998,
          price: 15,
          des: '浅烘焙咖啡',
          icon_id: 11
        },
        {
          id_: '12',
          name: '中烘焙咖啡',
          stock: 91,
          price: 13,
          des: 'xx',
          icon_id: 12
        },
        {
          id_: '13',
          name: '深烘焙咖啡',
          stock: 77,
          price: 8,
          des: '深烘焙咖啡',
          icon_id: 13
        },
        {
          id_: '14',
          name: '意式咖啡',
          stock: 59,
          price: 13,
          des: 'xx',
          icon_id: 14
        },
        {
          id_: '15',
          name: '手冲咖啡',
          stock: 91,
          price: 19,
          des: '手冲咖啡',
          icon_id: 15
        },
        {
          id_: '16',
          name: '法压咖啡',
          stock: 99,
          price: 21,
          des: 'xx',
          icon_id: 16
        }
      ]
    },
    {
      name: '罗布斯塔咖啡豆',
      logo_id: 20,
      foodList: [
        {
          id_: '21',
          name: '速溶咖啡',
          stock: 99,
          price: 32,
          des: 'sdfs',
          icon_id: 21
        },
        {
          id_: '22',
          name: '纯咖啡',
          stock: 76,
          price: 45,
          des: 'sdfs',
          icon_id: 22
        },
        {
          id_: '23',
          name: '牛奶咖啡',
          stock: 73,
          price: 31,
          des: 'sdfs',
          icon_id: 23
        }
      ]
    },
    {
      name: '浅烘焙咖啡',
      logo_id: 30,
      foodList: [
        {
          id_: '31',
          name: '花式咖啡',
          stock: 9,
          price: 15,
          des: 'adgadfg',
          icon_id: 31
        },
        {
          id_: '32',
          name: '拿铁',
          stock: 88,
          price: 18,
          des: 'adgadfg',
          icon_id: 32
        },
        {
          id_: '33',
          name: '冷萃咖啡',
          stock: 99,
          price: 19,
          des: 'adgadfg',
          icon_id: 33
        }
      ]
    },
    {
      name: '意式咖啡',
      logo_id: 40,
      foodList: [
        {
          id_: '31',
          name: '意式咖啡01',
          stock: 9,
          price: 15,
          des: 'adgadfg',
          icon_id: 41
        },
        {
          id_: '42',
          name: '意式咖啡02',
          stock: 88,
          price: 18,
          des: 'adgadfg',
          icon_id: 42
        },
        {
          id_: '43',
          name: '意式咖啡03',
          stock: 99,
          price: 19,
          des: 'adgadfg',
          icon_id: 43
        }
      ]
    },
    {
      name: '牛奶咖啡',
      logo_id: 50,
      foodList: [
        {
          id_: '51',
          name: '可乐',
          stock: 23,
          price: 5,
          des: 'adgadfg',
          icon_id: 51
        },
        {
          id_: '52',
          name: '牛奶咖啡01',
          stock: 11,
          price: 10,
          des: 'adgadfg',
          icon_id: 52
        },
        {
          id_: '53',
          name: '牛奶咖啡02',
          stock: 44,
          price: 6,
          des: 'adgadfg',
          icon_id: 53
        }
      ]
    }
  ]

}

let mydata = new MyData()

export default mydata as MyData
import { ValuesBucket } from "@kit.ArkData"
import Food from "./Food"

export interface OrderItem {
  id_: string;
  name: string;
  stock: number;
  price: number;
  des: string;
  icon_id: number;
}

interface GeneratedTypeLiteralInterface_1 {
  orderId: string;
  items: Food[];
  totalPrice: number;
  eatType: string;
  createTime?: string;
}

export class Order {
  orderId: string;
  items: OrderItem[];
  totalPrice: number;
  eatType: string;
  createTime: string;

  constructor(params: GeneratedTypeLiteralInterface_1) {
    this.orderId = params.orderId;
    this.items = params.items.map(food => this.convertFoodToOrderItem(food));
    this.totalPrice = params.totalPrice;
    this.eatType = params.eatType;
    this.createTime = params.createTime || new Date().toISOString();
  }

  private convertFoodToOrderItem(food: Food): OrderItem {
    return {
      id_: food.id_,
      name: food.name,
      stock: food.stock,
      price: food.price,
      des: food.des,
      icon_id: food.icon_id
    };
  }

  toValuesBucket(): ValuesBucket {
    return {
      'order_id': this.orderId,
      'order_items': JSON.stringify(this.items),
      'total_price': this.totalPrice,
      'eat_type': this.eatType,
      'create_time': this.createTime
    };
  }
}






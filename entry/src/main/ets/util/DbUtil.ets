import { relationalStore, ValuesBucket } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import Food from '../modle/Food';
import { Order, OrderItem } from '../modle/Order';

class DbUtil {
  private STORE_CONFIG: relationalStore.StoreConfig = {
    name: "RdbTest.db",
    securityLevel: relationalStore.SecurityLevel.S1
  };

  private rdbStore?: relationalStore.RdbStore;

  private FOOD_TABLE = 'FOOD';
  private ORDER_TABLE = 'ORDERS';

  private SQL_CREATE_FOOD = `CREATE TABLE IF NOT EXISTS ${this.FOOD_TABLE} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_ TEXT,
    name TEXT,
    stock INTEGER,
    price REAL,
    des TEXT,
    icon_id INTEGER
  )`;

  private SQL_CREATE_ORDER = `CREATE TABLE IF NOT EXISTS ${this.ORDER_TABLE} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id TEXT UNIQUE,
    order_items TEXT,
    total_price REAL,
    eat_type TEXT,
    create_time TEXT
  )`;

  init(context: Context): void {
    relationalStore.getRdbStore(context, this.STORE_CONFIG,
      (err: BusinessError, rdbStore: relationalStore.RdbStore) => {
        if (err) {
          return;
        }
        this.rdbStore = rdbStore;
        this.executeSql(this.SQL_CREATE_FOOD);
        this.executeSql(this.SQL_CREATE_ORDER);
      });
  }

  private executeSql(sql: string): void {
    this.rdbStore?.executeSql(sql, (err) => {
      // SQL执行
    });
  }

  // ========== 食品操作 ==========
  async insert(item: Food): Promise<number> {
    const values: ValuesBucket = {
      'id_': item.id_,
      'name': item.name,
      'stock': item.stock,
      'price': item.price,
      'des': item.des,
      'icon_id': item.icon_id
    };

    try {
      const rowId = await this.rdbStore?.insert(this.FOOD_TABLE, values);
      return rowId ?? -1;
    } catch (error) {
      return -1;
    }
  }

  async delete(id_: string): Promise<number> {
    const predicates = new relationalStore.RdbPredicates(this.FOOD_TABLE);
    predicates.equalTo('id_', id_);

    try {
      const rowCount = await this.rdbStore?.delete(predicates);
      return rowCount ?? 0;
    } catch (error) {
      return 0;
    }
  }

  async batchDelete(ids: string[]): Promise<number> {
    const predicates = new relationalStore.RdbPredicates(this.FOOD_TABLE);
    predicates.in('id_', ids);

    try {
      const rowCount = await this.rdbStore?.delete(predicates);
      return rowCount ?? 0;
    } catch (error) {
      return 0;
    }
  }

  async queryAll(): Promise<Food[]> {
    const predicates = new relationalStore.RdbPredicates(this.FOOD_TABLE);

    try {
      const resultSet = await this.rdbStore?.query(predicates);
      return this.parseFoodResultSet(resultSet);
    } catch (error) {
      return [];
    }
  }

  private parseFoodResultSet(resultSet?: relationalStore.ResultSet): Food[] {
    const list: Food[] = [];

    if (!resultSet) return list;

    while (resultSet.goToNextRow()) {
      const data: Food = {
        id_: resultSet.getString(resultSet.getColumnIndex('id_')),
        name: resultSet.getString(resultSet.getColumnIndex('name')),
        stock: resultSet.getLong(resultSet.getColumnIndex('stock')),
        price: resultSet.getDouble(resultSet.getColumnIndex('price')),
        des: resultSet.getString(resultSet.getColumnIndex('des')),
        icon_id: resultSet.getLong(resultSet.getColumnIndex('icon_id'))
      };
      list.push(data);
    }

    resultSet.close();
    return list;
  }

  // ========== 订单操作 ==========
  async saveOrder(order: Order): Promise<number> {
    try {
      const rowId = await this.rdbStore?.insert(this.ORDER_TABLE, order.toValuesBucket());
      return rowId ?? -1;
    } catch (error) {
      return -1;
    }
  }

  async queryAllOrders(): Promise<Order[]> {
    const predicates = new relationalStore.RdbPredicates(this.ORDER_TABLE);
    predicates.orderByDesc('create_time');

    try {
      const resultSet = await this.rdbStore?.query(predicates);
      return this.parseOrderResultSet(resultSet);
    } catch (error) {
      return [];
    }
  }

  async queryRecentOrders(limit: number = 5): Promise<Order[]> {
    const predicates = new relationalStore.RdbPredicates(this.ORDER_TABLE);
    predicates.orderByDesc('create_time');
    
    // 在数据库层面限制查询结果数量
    // 注意：HarmonyOS的RdbPredicates目前不支持limit方法
    // 所以我们需要先查询所有数据，然后在内存中限制

    try {
      const resultSet = await this.rdbStore?.query(predicates);
      const allOrders = this.parseOrderResultSet(resultSet);
      // 返回最近limit个订单
      return allOrders.slice(0, limit);
    } catch (error) {
      console.error('查询最近订单失败:', error);
      return [];
    }
  }

  private parseOrderResultSet(resultSet?: relationalStore.ResultSet): Order[] {
    const orders: Order[] = [];

    if (!resultSet) return orders;

    while (resultSet.goToNextRow()) {
      try {
        const order = new Order({
          orderId: resultSet.getString(resultSet.getColumnIndex('order_id')),
          items: JSON.parse(resultSet.getString(resultSet.getColumnIndex('order_items'))),
          totalPrice: resultSet.getDouble(resultSet.getColumnIndex('total_price')),
          eatType: resultSet.getString(resultSet.getColumnIndex('eat_type')),
          createTime: resultSet.getString(resultSet.getColumnIndex('create_time'))
        });
        orders.push(order);
      } catch (error) {
      }
    }

    resultSet.close();
    return orders;
  }
}

let dbUtil = new DbUtil();
export default dbUtil as DbUtil;
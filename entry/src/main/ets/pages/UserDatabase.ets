import { relationalStore, ValuesBucket } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import common from '@ohos.app.ability.common';

export class UserDatabase {
  private rdbStore: relationalStore.RdbStore | null = null;
  private context: common.UIAbilityContext = getContext() as common.UIAbilityContext;

  async initDatabase(): Promise<void> {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: 'UserDB.db',
      securityLevel: relationalStore.SecurityLevel.S1
    };

    const SQL_CREATE_TABLE = `
      CREATE TABLE IF NOT EXISTS user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    `;

    try {
      this.rdbStore = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
      await this.rdbStore.executeSql(SQL_CREATE_TABLE);
    } catch (err) {
      throw new Error(`Database init failed: ${JSON.stringify(err)}`);
    }
  }

  async registerUser(username: string, password: string): Promise<boolean> {
    if (!this.rdbStore) {
      await this.initDatabase();
    }

    const valueBucket: ValuesBucket = {
      'username': username,
      'password': password
    };

    try {
      await this.rdbStore!.insert('user', valueBucket);
      return true;
    } catch (err) {
      const businessErr = err as BusinessError;
      if (businessErr.code === 1) { // SQLite constraint error
        return false;
      }
      throw new Error(`Registration failed: ${JSON.stringify(err)}`);
    }
  }

  async validateUser(username: string, password: string): Promise<boolean> {
    if (!this.rdbStore) {
      await this.initDatabase();
    }

    const predicates = new relationalStore.RdbPredicates('user');
    predicates.equalTo('username', username);
    predicates.equalTo('password', password);

    try {
      const resultSet = await this.rdbStore!.query(predicates, ['id']);
      const count = resultSet.rowCount;
      resultSet.close();
      return count > 0;
    } catch (err) {
      throw new Error(`Validation failed: ${JSON.stringify(err)}`);
    }
  }

  async checkUserExists(username: string): Promise<boolean> {
    if (!this.rdbStore) {
      await this.initDatabase();
    }

    const predicates = new relationalStore.RdbPredicates('user');
    predicates.equalTo('username', username);

    try {
      const resultSet = await this.rdbStore!.query(predicates, ['id']);
      const count = resultSet.rowCount;
      resultSet.close();
      return count > 0;
    } catch (err) {
      throw new Error(`Check user failed: ${JSON.stringify(err)}`);
    }
  }
}

export const userDB = new UserDatabase();


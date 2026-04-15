import { emitter } from '@kit.BasicServicesKit';

class GlobalState {
  private static instance: GlobalState;
  
  // 用户余额
  private userBalance: number = 2350;
  
  // 余额更新事件ID
  public static readonly BALANCE_UPDATE_EVENT_ID = 3;
  
  private constructor() {
    this.loadBalanceFromStorage();
  }
  
  public static getInstance(): GlobalState {
    if (!GlobalState.instance) {
      GlobalState.instance = new GlobalState();
    }
    return GlobalState.instance;
  }

  // 从Preferences加载余额
  private async loadBalanceFromStorage(): Promise<void> {
    try {
      const PreferencesUtil = await import('./PreferencesUtil');
      const balance = await PreferencesUtil.default.getPreferenceValue('user_balance', 2350) as number;
      this.userBalance = balance;
    } catch (error) {
      // 加载失败使用默认值
    }
  }

  // 获取当前余额
  public getBalance(): number {
    return this.userBalance;
  }

  // 更新余额（并保存到Preferences）
  public async updateBalance(newBalance: number): Promise<void> {
    const oldBalance = this.userBalance;
    this.userBalance = newBalance;
    
    try {
      const PreferencesUtil = await import('./PreferencesUtil');
      await PreferencesUtil.default.putPreferenceValue('user_balance', newBalance);
      
      // 发送余额更新事件
      this.emitBalanceUpdate(oldBalance, newBalance);
    } catch (error) {
      // 恢复旧值
      this.userBalance = oldBalance;
      throw new Error(`保存余额失败: ${error.message || error}`);
    }
  }
  
  // 扣款
  public async deductBalance(amount: number): Promise<number> {
    if (amount <= 0) {
      throw new Error('扣款金额必须大于0');
    }
    
    if (this.userBalance < amount) {
      throw new Error('余额不足');
    }
    
    const newBalance = this.userBalance - amount;
    await this.updateBalance(newBalance);
    return newBalance;
  }

  // 发送余额更新事件
  private emitBalanceUpdate(oldBalance: number, newBalance: number): void {
    emitter.emit({ eventId: GlobalState.BALANCE_UPDATE_EVENT_ID }, { 
      data: { 
        paymentAmount: oldBalance - newBalance,
        oldBalance: oldBalance,
        newBalance: newBalance
      } 
    });
  }
}

export default GlobalState.getInstance();
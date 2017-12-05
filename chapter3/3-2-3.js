function makeWithdraw(balance) {
  return amount => {
    if(balance < amount) throw new Expcetion('no enough balance')
    return balance = balance - amount
  }
}

let w1 = makeWithdraw(100)

w1(50)

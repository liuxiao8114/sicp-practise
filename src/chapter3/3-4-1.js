// The nature of time in concurrent systems
module.exports = {
  Account
}

function Account(balance) {
  this.balance = balance
}

Account.prototype = {
  constructor: Account,
  withdraw(amount) {
    this.balance -= amount
    return this.balance
  },
  deposit(amount) {
    this.balance += amount
    return this.balance
  },
  dispatch(m) {
    if(!this[m])
      throw new Error(`Unknown action name: ${m}`)
    return this[m].bind(this)
  }
}

function exchange(from, to) {
  const diff = from - to
  from.withdraw(diff)
  to.deposit(diff)
}

function Serializer() {

}

function Mutex() {

}

Mutex.acquire = () => {

}

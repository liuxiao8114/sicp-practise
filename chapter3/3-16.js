function Node() {
  let node, next
}

Node.prototype.car = () => this.node
Node.prototype.cdr = () => this.next

function isPair(x) {
  return x instanceof Node
}

function countNode(x) {
  if(!isPair(x)) return 0
  return countNode(x.car()) + countNode(x.cdr()) + 1
}

let n1 = new Node(),
    n2 = new Node(),
    n3 = new Node()

n1.next = n2
n1.node = n3

n2.next = null
n2.node = n3

n3.node = 'a'
n3.next = 'b'

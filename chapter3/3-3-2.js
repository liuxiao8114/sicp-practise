function Node(value, next, prev) {
  this.next = next
  this.prev = prev
  this.value = value
}

function Queue() {
  this.first = null
  this.rear = null
}

Queue.prototype.enqueue = function(n) {
  if(!(n instanceof Node)) {
    n = new Node(n)
  }
  if(this.first === null) {
    this.first = n
    this.rear = n
  } else {
    let temp = this.rear
    temp.next = n
    this.rear = n
  }
}

Queue.prototype.search = function() {
  
}

Queue.prototype.dequeue = function() {

}

first enquque c
null c null
last enqueue f
null c f null

first enquque x

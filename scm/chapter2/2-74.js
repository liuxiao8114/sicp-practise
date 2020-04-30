/*
如何组织数据? make-data
如何存储数据? put
如何定位抓取数据?

*/
let makePersonalFile = (name, ...params) => {
  if(!name) throw new Error("must have name")

  const { company, salary, address } = params
  return {
    name,

  }
}

let files = fileList => {
  map(file => {
    makePersonalFile(file)
  }, fileList)
}


{ configure, jail_code, run, configure-all } = require('./codejail').mocked

configure-all()

jail_code("node", "x+1", "p1", { f1: "f1", f2: "f2" }, "", "x1")
.then -> run("mnode", "x+y+z")
.then (-> console.log it), (-> console.log it)
    

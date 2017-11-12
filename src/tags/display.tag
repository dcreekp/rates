<display>
  <h2 show={!opts.value}>{ opts.b_name }</h2>
  <h3 show={opts.value}>{opts.amount} {opts.b_name} is {opts.value} {opts.q_name}</h3>
  <p show={!opts.value}>currency exchange calculator</p>
  <p show={opts.value}>{opts.now}</p>

  <script>
    // the tag invoke this function when its 'display' event is triggered
    // it displays the information included in the current object
    // formatted to display nicely with currency symbols etc.
    this.on('display', (current) => {
      let prop = { style: "currency", currency: current.base}
      current.amount = (current.amount * 1).toLocaleString('en', prop)
      current.q_name = current.qg_name
      prop.currency = current.quoting
      current.value = (current.value * 1).toLocaleString('en', prop)
      this.opts = current
    })
    // updates the opts of the tag with the info in the current-rates tag's 
    // 'current' object
    this.on('update', () => {
      this.opts = this.parent.current
    })
  </script>
</display>

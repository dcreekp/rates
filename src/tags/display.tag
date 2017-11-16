<display>
  <h2 show={!opts.value}>{ opts.b_name }</h2>
  <h3 show={opts.value}>{opts.amount} {opts.b_name} = {opts.value} {opts.q_name}</h3>
  <p show={!opts.value}>currency exchange calculator</p>
  <p show={opts.value}>{opts.now}</p>

  <script>
    // function to format the display of currencies' amount and value
    const format = (current) => {
      let prop = { style: "currency", currency: current.base},
          amount = current.amount * 1;
      if (isNaN(amount)) {
        current.value = '0'
      } else {
        current.amount = (amount).toLocaleString('en', prop)
      }
      prop.currency = current.quoting
      current.value = (current.value * 1).toLocaleString('en', prop)
      return current
    }

    this.on('display', (current) => {
      this.opts = format(current)
    })
    this.on('update', () => {
      this.opts = this.parent.current
    })
  </script>
</display>

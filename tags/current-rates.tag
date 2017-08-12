<current-rates>
  <display></display>
  <amount></amount>
  <selector></selector>
  <converter></converter>


  <script>
    this.on('mount', () => {
      opts.callback(this)
    })
    this.on('data_loaded', (data) => {
      opts.rates = data.rates
      opts.base = data.base
      this.update()
      var convert = {
        base: opts.base,
      }
      riot.mount('converter', convert)

      var select = {
        placeholder: 'select a currency',
        filter: 'text',
        options: data.quotes
      }

      var quoting = riot.mount('selector', {select:select})

      quoting[0].on('select', (item) => {
        var selected = item.text.slice(0,3)
        riot.mount('display', {amount:selected})
        convert.quoting = selected
        convert.rate = opts.rates[selected]
        riot.mount('converter', convert)
      })


    })
  </script>

</current-rates>

<display>

  <h2 show={!opts.amount}>British Pound Sterling</h2>
  <h2 show={opts.amount}>{opts.amount} is {opts.amount}</h2>
  <p show={!opts.amount}>currency exchange calculator</p>

</display>

<amount>
  <input type="text"
         ref="amount"
         placeholder="enter amount"
         class="field">
  <script>
    // make the value of the input available
  </script>
</amount>

<converter>
  <input show={ opts.base }
         type="submit"
         ref="button"
         value="convert to { opts.base }"
         onclick={ check }>
  <script>
    // collect the relevant info calculate and send to display
    // base quote amount and converted value
    this.check = () => {
      console.log(this.parent.refs.amount.value)
    }
  </script>
</converter>

<current-rates>
  <display></display>
  <input type="text"
         ref="amount"
         placeholder="enter amount"
         class="field">
  <selector></selector>
  <input show={ opts.base }
         type="submit"
         ref="button"
         value="convert to { opts.base }"
         onclick={ check }>


  <script>
    this.on('mount', () => {
      opts.callback(this)
    })
    this.on('data_loaded', (data) => {
      opts.rates = data.rates
      opts.base = data.base
      this.update()
      this.convert = {
        base: opts.base,
      }
      riot.update('display', this.convert)

      let select = {
        placeholder: 'select a currency',
        filter: 'text',
        options: data.quotes
      }

      let quoting = riot.mount('selector', {select:select})

      quoting[0].on('select', (item) => {
        let selected = item.text.slice(0,3)
        this.convert.quoting = selected
        this.convert.rate = opts.rates[selected]
        this.update()
      })

    this.check = () => {
      this.convert.amount = this.refs.amount.value
      this.convert.value = (this.convert.amount * this.convert.rate).toFixed(2)
      this.tags.display.trigger('convert', this.convert)
    }

    })
  </script>

</current-rates>

<display>

  <h2 show={!opts.value}>British Pound Sterling</h2>
  <h2 show={opts.value}>{opts.amount}{opts.quoting} is {opts.value}{opts.base}</h2>
  <p show={!opts.value}>currency exchange calculator</p>

  <script>
    this.on('convert', (data) => {
      this.opts = data
    })
  </script>

</display>

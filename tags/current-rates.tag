<current-rates>
  <display show={ opts.base }></display>
  <input show={ opts.base }
         type="text"
         ref="amount"
         placeholder="enter amount"
         class="field">
  <selector show={ opts.base }></selector>
  <input show={ opts.base }
         type="submit"
         ref="button"
         value="convert to { opts.base }"
         onclick={ convert }>


  <script>
    var now
    this.on('mount', () => {
      let d = new Date
      now = new Date(d.getFullYear(), d.getMonth(), d.getDate(), d.getHours())
      now = now.toLocaleDateString() + ' ' + now.toLocaleTimeString()
      //const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
      opts.callback(this)
    })
    this.on('data_loaded', (data) => {
      let index = data.index
      opts.base = data.base
      this.current = {
        b_name: index[data.base].name,
        base: opts.base,
        now: now,
      }
      this.update()

      let quotes = []
      for (let symbol in index) {
        quotes.push({'text': symbol + ' - ' + index[symbol].name})
      }
      let select = {
        placeholder: 'select a currency',
        filter: 'text',
        options: quotes
      }

      let quoting = riot.mount('selector', {select:select})

      quoting[0].on('select', (item) => {
        let selected = item.text.slice(0,3)
        this.current.quoting = selected
        this.current.qg_name = index[selected].name
        this.current.rate = index[selected].rate
        this.update()
      })

    this.convert = () => {
      this.current.amount = this.refs.amount.value
      this.current.value = (this.current.amount * this.current.rate).toFixed(2)
      this.tags.display.trigger('display', this.current)
    }

    })
  </script>

</current-rates>

<display>

  <h2 show={!opts.value}>{ opts.b_name }</h2>
  <h3 show={opts.value}>{opts.amount} {opts.q_name}({opts.quote}) is {opts.value} {opts.b_name}({opts.base})</h3>
  <p show={!opts.value}>currency exchange calculator</p>
  <p show={opts.value}>{opts.now}</p>


  <script>
    this.on('display', (current) => {
      current.quote = current.quoting
      current.q_name = current.qg_name
      this.opts = current
    })
    this.on('update', () => {
      this.opts = this.parent.current
    })
  </script>

</display>

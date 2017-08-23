<current-rates>
  <div class="o-grid">
    <display show={ opts.base }></display>
  </div>
  <div class="o-grid">
    <div class="o-grid__cell">
      <input show={ opts.base }
             type="text"
             ref="amount"
             placeholder="enter amount"
             class="field">
    </div>
    <div class="o-grid__cell">
      <input show={ opts.base }
             class="c-button c-button--success"
             type="submit"
             ref="button"
             value="&#8608;"
             onclick={ convert }>
    </div>
    <div class="o-grid__cell">
      <selector show={ opts.base }></selector>
    </div>
  </div>
  <script>
    var now
    this.on('mount', () => {
      let d = new Date
      now = new Date(d.getFullYear(), d.getMonth(), d.getDate(), d.getHours())
      now = now.toLocaleDateString() + ' ' + now.toLocaleTimeString()
      //const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
      opts.callback(this, opts.base)
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
  <h3 show={opts.value}>{opts.amount} {opts.b_name} is {opts.value} {opts.q_name}</h3>
  <p show={!opts.value}>currency exchange calculator</p>
  <p show={opts.value}>{opts.now}</p>


  <script>
    this.on('display', (current) => {
      let prop = { style: "currency", currency: current.base}
      current.amount = (current.amount * 1).toLocaleString('en', prop)
      current.q_name = current.qg_name
      prop.currency = current.quoting
      current.value = (current.value * 1).toLocaleString('en', prop)
      this.opts = current
    })
    this.on('update', () => {
      this.opts = this.parent.current
    })
  </script>

</display>

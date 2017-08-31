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
      <selector id="from" show={ opts.base }></selector>
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
      <selector id="to" show={ opts.base }></selector>
    </div>
  </div>
  <script>
    import route from 'riot-route'
    var now
    this.on('mount', () => {
      let d = new Date
      now = new Date(d.getFullYear(), d.getMonth(), d.getDate(), d.getHours())
      now = now.toLocaleDateString() + ' ' + now.toLocaleTimeString()
      //const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
      opts.callback(this, opts.base)
    })
    this.on('data_loaded', (response) => {
      let quotes = response.data.quotes,
          bases = response.data.bases;
      opts.base = response.data.base
      this.current = {
        b_name: quotes[opts.base].name,
        base: opts.base,
        now: now,
      }

      let from = []
      for (let i=0; i<bases.length; i++) {
        from.push({'text': bases[i].symbol + ' - ' + bases[i].name,
                   'symbol': bases[i].symbol
                  })
      }
      let select_from = {
        placeholder: 'select a currency',
        filter: 'text',
        options: from
      }
      let to = []
      for (let symbol in quotes) {
        to.push({'text': symbol + ' - ' + quotes[symbol].name,
                 'symbol': symbol
                })
      }
      let select_to = {
        placeholder: 'select a currency',
        filter: 'text',
        options: to
      }

      let rebase = riot.mount('selector#from',
                              {select:select_from, current: opts.base})
      let quoting = riot.mount('selector#to', {select:select_to})

      this.update()

      rebase[0].on('select', (item) => {
        let selected = item.symbol
        route(selected)
      })

      quoting[0].on('select', (item) => {
        let selected = item.symbol
        this.current.quoting = selected
        this.current.qg_name = quotes[selected].name
        this.current.rate = quotes[selected].rate
        this.update()
      })

    this.convert = () => {
      this.current.amount = this.refs.amount.value
      this.current.value = (this.current.amount * this.current.rate)
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

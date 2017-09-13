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
      opts.callback(this, opts.base, opts.quote, opts.amount)
    })
    this.on('data_loaded', (response) => {
      const quotes = response.data.quotes,
          bases = response.data.bases,
          quote = response.data.quote,
          amount = response.data.amount;
      opts.base = response.data.base

      this.convert = () => {
        this.current.amount = this.refs.amount.value
        this.current.value = (this.current.amount * this.current.rate)
        this.tags.display.trigger('display', this.current)
      }
      this.current = {
        b_name: quotes[opts.base].name,
        base: opts.base,
        now: now,
      }

      if (quote) {
        this.current.quoting = quote
        this.current.qg_name = quotes[quote].name
        this.current.rate = quotes[quote].rate
      }
      if (amount) {
        this.refs.amount.value = amount * 1
        this.convert()
      }

      const selectorOptions = (subset = null) => {
        let selection = []
        let set = subset ? bases.filter(base => base.symbol in subset) : bases
        for (let i=0; i<set.length; i++) {
          selection.push({'text': set[i].symbol + ' - ' + set[i].name,
                          'symbol': set[i].symbol
                         })
        }
        return selection
      }

      let select_from = {
        placeholder: 'select a currency',
        filter: 'text',
        options: selectorOptions()
      }
      let select_to = {
        placeholder: 'select a currency',
        filter: 'text',
        options: selectorOptions(quotes)
      }

      let rebase = riot.mount('selector#from',
                              {select:select_from, current: opts.base})
      let quoting = riot.mount('selector#to',
                               {select:select_to, current: quote})

      this.update()

      rebase[0].on('select', (item) => {
        let selected = item.symbol,
            quote_selected = quoting[0].opts.current,
            amount = this.refs.amount.value;
        if (amount && quote_selected) {
          route(selected + '/' + quote_selected + '/' + amount)
        } else if (quote_selected) {
          route(selected + '/' + quote_selected)
        } else {
          route(selected)
        }
      })

      quoting[0].on('select', (item) => {
        let selected = item.symbol,
            amount = this.refs.amount.value;
        if (amount) {
          route(opts.base + '/' + selected + '/' + amount)
        } else {
          route(opts.base + '/' + selected)
        }
      })
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

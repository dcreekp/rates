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
             oninput={ convert }
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
             value="&#8644;"
             onclick={ invert }>
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
      
      // the currentRatesCallback to get the data from backend
      opts.callback(this, opts.base, opts.quote, opts.amount)
    })

    // what happens when the data is loaded
    this.on('data_loaded', (response) => {

      // collect the data
      const quotes = response.data.quotes,
          bases = response.data.bases,
          base = response.data.base,
          quote = response.data.quote,
          amount = response.data.amount;
      // loads the base into the opts of the tag
      opts.base = base
 
      // current object gets updated with the newly loaded data
      this.current = {
        b_name: quotes[base].name,
        base: base,
        now: now,
      }

      // function to update the current information and then trigger
      // the display method of the display tag
      this.convert = () => {
        this.current.amount = this.refs.amount.value
        this.current.value = (this.current.amount * this.current.rate)
        this.tags.display.trigger('display', this.current)
      }

      // function to invert the base currency with the current quoting currency
      this.invert = () => {
        let amount = this.refs.amount.value
        if (amount && quote) {
          route(quote + '/' + base + '/' + amount)
        } else if (quote) {
          route(quote + '/' + base)
        }
      }

      // current object gets updated if quote exists
      if (quote) {
        this.current.quoting = quote
        this.current.qg_name = quotes[quote].name
        this.current.rate = quotes[quote].rate
      }
      // if amount exists the amount is inserted into the inputbox
      // and the convert function is invoked
      if (amount) {
        this.refs.amount.value = amount * 1
        this.convert()
      }

      // defines a function that returns a selection of the currencies that 
      // will be included in the 'from' and 'to' dropdown selectors
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

      // declaring variables with necessary attributes 
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

      // mounts and assigns the 'from' and 'to' dropdown selector
      // mounts the selector tag with arguments defined above
      let rebase = riot.mount('selector#from',
                              {select:select_from, current: base})
      let quoting = riot.mount('selector#to',
                               {select:select_to, current: quote})

      // updates the current-rates tag, and thus its child tags
      this.update()

      // the 'from' selector will invoke this function when the 'select' event
      // is triggered
      // will call for new routes corresponding to the existing information and
      // the new selection
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

      // the 'to' selector will invoke this function when its 'select' event is 
      // triggered
      // will call for new routes corresponding to the existing information and
      // the new selection
      quoting[0].on('select', (item) => {
        let selected = item.symbol,
            amount = this.refs.amount.value;
        if (amount) {
          route(base + '/' + selected + '/' + amount)
        } else {
          route(base + '/' + selected)
        }
      })
    })
  </script>
</current-rates>

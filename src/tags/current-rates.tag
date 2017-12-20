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
    let now

    // defines a function that returns a list of the currency symbols to be
    // included in the 'from' and 'to' dropdown selectors
    // will need to use js find method to extract the current base quoting
    // symbol to the top of the list
    // or put the base or quoting symbol at the top of list with if statement
    const selectorOptions = (quotes) => {
      let selection = []
      Object.keys(quotes).forEach((symbol) => {
        selection.push({'text': symbol, 'symbol': symbol})
      })
      return selection
    }

    this.on('mount', () => {
      let d = new Date
      now = new Date(
          d.getFullYear(), d.getMonth(), d.getDate(), d.getHours())
          //d.getMinutes())
      now = now.toLocaleDateString() + ' ' + now.toLocaleTimeString(
          [], {'hour':'2-digit', 'minute': '2-digit', localeMatcher: 'lookup'})
      //const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      // the currentRatesCallback to get the data from backend
      opts.callback(this, opts.base, opts.quote, opts.amount)
    })

    this.on('data_loaded', (response) => {

      // collect the data
      const quotes = response.data.quotes,
          base = response.data.base,
          quote = response.data.quote;

      // loads the base into the opts of the tag
      // so that components that don't need conversion value can show early
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
        if (quote) route(quote + '/' + base)
      }

      if (quote) {
        this.current.quoting = quote
        this.current.q_name = quotes[quote].name
        this.current.rate = quotes[quote].rate
        // amount defaults to 1 if there is quoting currency
        if (!this.refs.amount.value) this.refs.amount.value = 1
        // only invokes this.convert if a quoting currency is selected
        this.convert()
      } else {
        this.current.value = null
        this.refs.amount.value = null
      }

      // declaring variables with necessary attributes
      let select_from = {
        placeholder: 'select a currency',
        filter: 'text',
        options: selectorOptions(quotes)
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
      // and also invokes the convert function
      this.update()

      // the 'from' selector will invoke this function when the 'select' event
      // is triggered
      // will call for new routes corresponding to the existing information and
      // the new selection
      rebase[0].on('select', (item) => {
        let selected = item.symbol,
            quote_selected = quoting[0].opts.current;
        if (quote_selected) {
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
        let selected = item.symbol;
        route(base + '/' + selected)
      })
    })
  </script>
</current-rates>

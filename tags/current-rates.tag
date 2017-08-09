<current-rates>
  <rg-select></rg-select> <p>converts to: {opts.base}</p>
  <ul>
    <li each={quote in opts.quotes}>{ quote.symbol }-{quote.rate }</li>
  </ul>
  <script>
    this.on('mount', function() {
      opts.callback(this)
    })
    this.on('data_loaded', function(data) {
      opts.quotes = data.rates
      opts.symbols = data.symbols
      opts.base = data.base
      this.update()

      var select = {
        placeholder: 'select a currency',
        filter: 'symbol',
        options: data.symbols
      }

      var base = riot.mount('rg-select', {select:select})

      console.log(base, base[0])

      base[0].on('open', function () { console.log('open') })
             .on('close', function () { console.log('close') })
             .on('select', function () { console.log('select') })
    })
  </script>

</current-rates>

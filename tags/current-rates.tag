<current-rates>
  <rg-select></rg-select> <p>converts to: {opts.base}</p>

  <script>
    this.on('mount', () => {
      opts.callback(this)
    })
    this.on('data_loaded', (data) => {
      opts.rates = data.rates
      opts.base = data.base
      this.update()

      var select = {
        placeholder: 'select a currency',
        filter: 'text',
        options: data.quotes
      }

      var base = riot.mount('rg-select', {select:select})

      base[0].on('select', (item) => {
        var quote = item.text.slice(0,3)
        console.log('q', quote)
      })
    })
  </script>

</current-rates>

<current-rates>
  <rg-select></rg-select> <p>converts to: {opts.base}</p>

  <script>
    this.on('mount', function() {
      opts.callback(this)
    })
    this.on('data_loaded', function(data) {
      opts.rates = data.rates
      opts.base = data.base
      this.update()

      var select = {
        placeholder: 'select a currency',
        filter: 'text',
        options: data.quotes
      }

      var base = riot.mount('rg-select', {select:select})


      base[0].on('open', function () { console.log('open') })
             .on('close', function () { console.log('close') })
             .on('select', function () { console.log('select') })
    })
  </script>

</current-rates>

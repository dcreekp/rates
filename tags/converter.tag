<converter>

  <input type="text"
         ref="amount"
         placeholder="enter amount"
         class="field">

  <input type="submit"
         ref="button"
         value="convert to { opts.base }"
         onclick={ check }>


  <script>

    this.check = () => {
      console.log(opts.rate * this.refs.amount.value)
    }



  </script>
</converter>

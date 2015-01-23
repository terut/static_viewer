var data = JSON.parse(document.querySelector('#json').dataset.json);

Vue.component('item', {
  template: '#item-template',
  data: function () {
    return {
      open: false
    }
  },
  computed: {
    isFolder: function () {
      return this.model.children &&
        this.model.children.length
    }
  },
  methods: {
    toggle: function () {
      if (this.isFolder) {
        this.open = !this.open
      }
    }
  }
})

// boot up the demo
var demo = new Vue({
  el: '#demo',
  data: {
    treeData: data
  }
})

import consumer from "channels/consumer"

consumer.subscriptions.create({ channel: "AdminChannel" }, {
  received(data) {
    const adminTarget = document.querySelector(`[data-admin-id="${data.admin.id}"]`)
    if (adminTarget) {
      const date = new Date();
      const d1 = date.getFullYear() + '/' + ('0' + (date.getMonth() + 1)).slice(-2) + '/' +('0' + date.getDate()).slice(-2) + ' ' +  ('0' + date.getHours()).slice(-2) + ':' + ('0' + date.getMinutes()).slice(-2) + ':' + ('0' + date.getSeconds()).slice(-2) + '.' + date.getMilliseconds();
      adminTarget.innerHTML = d1
    }
  }
})
import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import * as bootstrap from "bootstrap"
import "./channels/consumer"
import "./channels/game_channel"

document.addEventListener('turbo:load', () => {
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })

  var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
  var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
    return new bootstrap.Popover(popoverTriggerEl)
  })
})

ActiveStorage.start()

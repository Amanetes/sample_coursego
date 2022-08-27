// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"
import "../stylesheets/application"
import "chartkick/chart.js"
import videojs from 'video.js'
import 'video.js/dist/video-js.css'
import "../trix-editor-overrides"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require("trix")
require("@rails/actiontext")

$(document).on('turbolinks:load', function(){
    let videoPlayer = videojs(document.getElementById('my-video'), {
        controls: true,
        playbackRates: [0.5, 1, 1.5],
        autoplay: false,
        fluid: true,
        preload: false,
        liveui: true,
        responsive: true,
        loop: false,
        // poster: "https://i.imgur.com/EihmtGG.jpg"
    })
    videoPlayer.addClass('video-js')
    videoPlayer.addClass('vjs-big-play-centered')
});
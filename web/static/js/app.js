import Elm from './elm/src/Main.elm';

window.Elm = Elm;

var node = document.getElementById("elm-land");

window.App = Elm.Main.embed(node);


App.ports.closeModal.subscribe(function() {
  console.log("close modal");
  $('#modal1').closeModal();
});

window.lol = $('.modal-trigger');
window.asdf = $('#modal1');

// Ugly hack, someone please improve :)
setTimeout(() => { $('.modal-trigger').leanModal(); }, 100);

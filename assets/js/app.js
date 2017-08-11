import "phoenix_html"
import { Socket } from "phoenix"

const Elm = require("../elm/Main");
Elm.Main.embed(document.getElementById("elm-main"));

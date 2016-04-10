module VirtualDom
    ( Node
    , text, node
    , toElement, fromElement
    , Property, property, attribute, attributeNS
    , on, onWithOptions, Options, defaultOptions
    , lazy, lazy2, lazy3
    ) where

{-| API to the core diffing algorithm. Can serve as a foundation for libraries
that expose more helper functions for HTML or SVG.

# Create
@docs Node, text, node

# Declare Properties and Attributes
@docs Property, property, attribute, attributeNS

# Events
@docs on, onWithOptions, Options, defaultOptions

# Optimizations
@docs lazy, lazy2, lazy3

# Conversions
@docs toElement, fromElement

-}

import Graphics.Element exposing (Element)
import Json.Decode as Json
import Native.VirtualDom


{-| An immutable chunk of data representing a DOM node. This can be HTML or SVG.
-}
type Node = Node


{-| Create a DOM node with a tag name, a list of HTML properties that can
include styles and event listeners, a list of CSS properties like `color`, and
a list of child nodes.

    import Json.Encode as Json

    hello : Node
    hello =
        node "div" [] [ text "Hello!" ]

    greeting : Node
    greeting =
        node "div"
            [ property "id" (Json.string "greeting") ]
            [ text "Hello!" ]
-}
node : String -> List Property -> List Node -> Node
node =
    Native.VirtualDom.node


{-| Just put plain text in the DOM. It will escape the string so that it appears
exactly as you specify.

    text "Hello World!"
-}
text : String -> Node
text =
    Native.VirtualDom.text


{-| Embed an `Node` value in Elm's rendering system. Like any other `Element`,
this requires a known width and height, so it is not yet clear if this can be
made more convenient in the future.
-}
toElement : Int -> Int -> Node -> Element
toElement =
    Native.VirtualDom.toElement


{-| Embed an `Element` as `Html`.
-}
fromElement : Element -> Node
fromElement =
    Native.VirtualDom.fromElement


-- PROPERTIES

{-| When using HTML and JS, there are two ways to specify parts of a DOM node.

  1. Attributes &mdash; You can set things in HTML itself. So the `class`
     in `<div class="greeting"></div>` is called an *attribute*.

  2. Properties &mdash; You can also set things in JS. So the `className`
     in `div.className = 'greeting'` is called a *property*.

So the `class` attribute corresponds to the `className` property. At first
glance, perhaps this distinction is defensible, but it gets much crazier.
*There is not always a one-to-one mapping between attributes and properties!*
Yes, that is a true fact. Sometimes an attribute exists, but there is no
corresponding property. Sometimes changing an attribute does not change the
underlying property. For example, as of this writing, the `webkit-playsinline`
attribute can be used in HTML, but there is no corresponding property!
-}
type Property = Property


{-| Create arbitrary *properties*.

    import JavaScript.Encode as Json

    greeting : Html
    greeting =
        node "div" [ property "className" (Json.string "greeting") ] [
          text "Hello!"
        ]

Notice that you must give the *property* name, so we use `className` as it
would be in JavaScript, not `class` as it would appear in HTML.
-}
property : String -> Json.Value -> Property
property =
    Native.VirtualDom.property


{-| Create arbitrary HTML *attributes*. Maps onto JavaScript’s `setAttribute`
function under the hood.

    greeting : Html
    greeting =
        node "div" [ attribute "class" "greeting" ] [
          text "Hello!"
        ]

Notice that you must give the *attribute* name, so we use `class` as it would
be in HTML, not `className` as it would appear in JS.
-}
attribute : String -> String -> Property
attribute =
    Native.VirtualDom.attribute


{-| Would you believe that there is another way to do this?! This corresponds
to JavaScript's `setAttributeNS` function under the hood. It is doing pretty
much the same thing as `attribute` but you are able to have "namespaced"
attributes. This is used in some SVG stuff at least.
-}
attributeNS : String -> String -> String -> Property
attributeNS =
    Native.VirtualDom.attributeNS


-- EVENTS

{-| Create a custom event listener.

    import Json.Decode as Json

    onClick : Signal.Address a -> Property
    onClick address =
        on "click" Json.value (\_ -> Signal.message address ())

You first specify the name of the event in the same format as with
JavaScript’s `addEventListener`. Next you give a JSON decoder, which lets
you pull information out of the event object. If that decoder is successful,
the resulting value is given to a function that creates a `Signal.Message`.
So in our example, we will send `()` to the given `address`.
-}
on : String -> Json.Decoder a -> (a -> Signal.Message) -> Property
on eventName decoder toMessage =
    Native.VirtualDom.on eventName defaultOptions decoder toMessage


{-| Same as `on` but you can set a few options.
-}
onWithOptions : String -> Options -> Json.Decoder a -> (a -> Signal.Message) -> Property
onWithOptions =
    Native.VirtualDom.on


{-| Options for an event listener. If `stopPropagation` is true, it means the
event stops traveling through the DOM so it will not trigger any other event
listeners. If `preventDefault` is true, any built-in browser behavior related
to the event is prevented. For example, this is used with touch events when you
want to treat them as gestures of your own, not as scrolls.
-}
type alias Options =
    { stopPropagation : Bool
    , preventDefault : Bool
    }


{-| Everything is `False` by default.

    defaultOptions =
        { stopPropagation = False
        , preventDefault = False
        }
-}
defaultOptions : Options
defaultOptions =
    { stopPropagation = False
    , preventDefault = False
    }


-- OPTIMIZATION

{-| A performance optimization that delays the building of virtual DOM nodes.

Calling `(view model)` will definitely build some virtual DOM, perhaps a lot of
it. Calling `(lazy view model)` delays the call until later. During diffing, we
can check to see if `model` is referentially equal to the previous value used,
and if so, we just stop. No need to build up the tree structure and diff it,
we know if the input to `view` is the same, the output must be the same!
-}
lazy : (a -> Node) -> a -> Node
lazy =
    Native.VirtualDom.lazy


{-| Same as `lazy` but checks on two arguments.
-}
lazy2 : (a -> b -> Node) -> a -> b -> Node
lazy2 =
    Native.VirtualDom.lazy2


{-| Same as `lazy` but checks on three arguments.
-}
lazy3 : (a -> b -> c -> Node) -> a -> b -> c -> Node
lazy3 =
    Native.VirtualDom.lazy3

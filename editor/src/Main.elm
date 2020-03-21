module Main exposing (main)

import Model as MD
import Browser
import App
import UI
import Url
import Browser.Navigation as BN

initialModel : MD.GlobalState
initialModel =
  { cursorCoords = { x = 0, y = 0 }
  , instantiatedItems = []
  , selectedItems = []
  , itemsUnderCursor = []
  , currentItemUnderCursor = Nothing
  , cursorMode = MD.FreeFormCursor
  , intent = MD.ToExplore
  , selectionMode = MD.SingleSelect
  , hoveredItem = Nothing
  , zoomFactor = 1.0
  , panCoords = { x = 0, y = 0 }
  , viewPortSize = (1000, 1000)
  }

init : MD.Flags -> Url.Url -> BN.Key -> (MD.GlobalState, Cmd MD.Msg)
init flags url key = (initialModel, Cmd.none)

main : Program MD.Flags MD.GlobalState MD.Msg
main =
  Browser.application
    { init = init
    , view = UI.view
    , update = App.update
    , subscriptions = App.subscriptions
    , onUrlChange = \_ -> MD.NoOp
    , onUrlRequest = \_ -> MD.NoOp
    }

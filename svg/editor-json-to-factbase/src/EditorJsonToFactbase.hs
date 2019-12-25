{-# LANGUAGE DeriveGeneric, DeriveAnyClass, NamedFieldPuns #-}

module EditorJsonToFactbase
  ( canvasItemsToFacts
  , factToProlog
  , factToLisp
  , Fact(..)
  , File(..)
  ) where

import qualified GHC.Generics as GG
import qualified Data.Aeson as DA
import qualified Types.Metadata as TMD
import qualified Data.ByteString.Lazy.Char8 as DBLC

stringPrefix = "struidG"

data File =
  File
    { version     :: String
    , moduleName  :: String
    , canvasItems :: [CanvasItem]
    } deriving (Show, GG.Generic, DA.ToJSON, DA.FromJSON)

data CanvasItem =
  CanvasItem
    { gitRef        :: String
    , gitUrl        :: String
    , id            :: Int
    , item          :: Item
    , manifestPath  :: String
    , kindName      :: String
    , sinkPinName   :: String
    , sourcePinName :: String
    } deriving (Show, GG.Generic, DA.ToJSON, DA.FromJSON)

data Coords =
  Coords
    { x :: Int
    , y :: Int
    } deriving (Show, GG.Generic, DA.ToJSON, DA.FromJSON)

data Item
  = Rect { topLeft :: Coords, bottomRight :: Coords }
  | Polyline { points :: [Coords] }
  | Ellipse { topLeft :: Coords, bottomRight :: Coords }
  deriving (Show, GG.Generic, DA.ToJSON, DA.FromJSON)

data Fact = Fact String String (Maybe String) deriving (Show)
type Id = Int
type Factbase = [Fact]
type StringMappings = [Fact]
type ConversionState = (Id, StringMappings, [TMD.Metadata], Factbase)

factToProlog :: Fact -> String
factToProlog (Fact pred subj (Just obj)) = pred ++ "(" ++ subj ++ "," ++ obj ++ ")."
factToProlog (Fact pred subj Nothing) = pred ++ "(" ++ subj ++ ")."

factToLisp :: Fact -> String
factToLisp (Fact pred subj _) = "(" ++ stringPrefix ++ pred ++ " \"" ++ subj ++ "\")"

canvasItemsToFacts :: [CanvasItem] -> (StringMappings, Factbase)
canvasItemsToFacts xs = (strings ++ newStrings, facts ++ metadataFacts)
  where
    (id, strings, metadata, facts) = convertItemsToFacts (0, [], [], []) xs
    metadataTextIdStr = "id" ++ show id
    metadataTagIdStr = "id" ++ show (id + 1)
    stringId = length strings
    newStrings = [Fact (show stringId) metadataString Nothing]
    escapeMetadata '"' = "\\\""
    escapeMetadata '\\' = "\\\\"
    escapeMetadata c = [c]
    metadataString = concat $ map escapeMetadata $ DBLC.unpack $ DA.encode metadata
    metadataFacts =
      [ Fact "metadata" metadataTagIdStr (Just metadataTextIdStr)
      , Fact "eltype" metadataTagIdStr (Just "metadata")
      , Fact "text" metadataTextIdStr (Just $ stringPrefix ++ show stringId)
      , Fact "bounding_box_top" metadataTextIdStr (Just "0")
      , Fact "bounding_box_left" metadataTextIdStr (Just "0")
      , Fact "bounding_box_bottom" metadataTextIdStr (Just "1")
      , Fact "bounding_box_right" metadataTextIdStr (Just "1")
      ]

convertItemsToFacts :: ConversionState -> [CanvasItem] -> ConversionState
convertItemsToFacts state [] = state
convertItemsToFacts state (x : xs) = convertItemsToFacts (getCanvasItemFacts state x) xs

getCanvasItemFacts :: ConversionState -> CanvasItem -> ConversionState
getCanvasItemFacts state canvasItem =
  case item canvasItem of
    Rect { topLeft, bottomRight } -> getRectFacts state canvasItem topLeft bottomRight
    Polyline { points } -> getPolylineFacts state canvasItem points
    Ellipse { topLeft, bottomRight } -> getEllipseFacts state canvasItem topLeft bottomRight

getEllipseFacts :: ConversionState -> CanvasItem -> Coords -> Coords -> ConversionState
getEllipseFacts (id, strings, metadata, facts) canvasItem topLeft bottomRight =
    (id + 2, strings ++ newStrings, metadata, facts ++ newFacts)
  where
    idStr = "id" ++ show id
    id2Str = "id" ++ show (id + 1)
    stringId = length strings
    newStrings = [Fact (show stringId) (kindName canvasItem) Nothing]
    newFacts =
      [ Fact "eltype" idStr (Just "ellipse")
      , Fact "ellipse" idStr Nothing
      , Fact "bounding_box_top" idStr (Just $ show $ y topLeft)
      , Fact "bounding_box_left" idStr (Just $ show $ x topLeft)
      , Fact "bounding_box_bottom" idStr (Just $ show $ y bottomRight)
      , Fact "bounding_box_right" idStr (Just $ show $ x bottomRight)
      , Fact "text" id2Str (Just $ stringPrefix ++ show stringId)
      , Fact "bounding_box_top" id2Str (Just $ show $ y topLeft + 1)
      , Fact "bounding_box_left" id2Str (Just $ show $ x topLeft + 1)
      , Fact "bounding_box_bottom" id2Str (Just $ show $ y bottomRight - 1)
      , Fact "bounding_box_right" id2Str (Just $ show $ x bottomRight - 1)
      ]

getPolylineFacts :: ConversionState -> CanvasItem -> [Coords] -> ConversionState
getPolylineFacts (id, strings, metadata, facts) canvasItem points =
    (id + 5, strings ++ newStrings, metadata, facts ++ newFacts)
  where
    edgeId = "id" ++ show id
    sourceId = "id" ++ show (id + 1)
    sinkId = "id" ++ show (id + 2)
    sourceLabelId = "id" ++ show (id + 3)
    sinkLabelId = "id" ++ show (id + 4)
    sourceStringId = length strings
    sinkStringId = sourceStringId + 1
    firstPoint = head points
    lastPoint = last points
    sourceStringFact = Fact (show sourceStringId) (sourcePinName canvasItem) Nothing
    sinkStringFact = Fact (show sinkStringId) (sinkPinName canvasItem) Nothing
    sourceLabelFacts = getPinFacts sourceLabelId sourceStringId firstPoint
    sinkLabelFacts = getPinFacts sinkLabelId sinkStringId lastPoint
    (newStrings, pinFacts) =
      case (sourcePinName canvasItem, sinkPinName canvasItem) of
        ("", "") ->
          ([], [])
        (x, "") ->
          ([sourceStringFact], sourceLabelFacts)
        ("", y) ->
          ([sinkStringFact], sinkLabelFacts)
        (x, y) ->
          ([sourceStringFact, sinkStringFact], sourceLabelFacts ++ sinkLabelFacts)
    newFacts =
      if length points < 2
      then error $ "Polyline has fewer than 2 points: " ++ show points
      else
        [ Fact "edge" edgeId Nothing
        , Fact "source" edgeId (Just sourceId)
        , Fact "eltype" sourceId (Just "port")
        , Fact "port" sourceId Nothing
        , Fact "bounding_box_top" sourceId (Just $ show $ y firstPoint - 20)
        , Fact "bounding_box_left" sourceId (Just $ show $ x firstPoint - 20)
        , Fact "bounding_box_bottom" sourceId (Just $ show $ y firstPoint + 20)
        , Fact "bounding_box_right" sourceId (Just $ show $ x firstPoint + 20)
        , Fact "sink" edgeId (Just sinkId)
        , Fact "eltype" sinkId (Just "port")
        , Fact "port" sinkId Nothing
        , Fact "bounding_box_top" sinkId (Just $ show $ y lastPoint - 20)
        , Fact "bounding_box_left" sinkId (Just $ show $ x lastPoint - 20)
        , Fact "bounding_box_bottom" sinkId (Just $ show $ y lastPoint + 20)
        , Fact "bounding_box_right" sinkId (Just $ show $ x lastPoint + 20)
        ] ++ pinFacts

getPinFacts :: String -> Int -> Coords -> [Fact]
getPinFacts labelId stringId point =
  let
    -- TODO: We don't know to which item the pin is associated with so we just
    -- have to place it further out for now. A future action is to modify the
    -- editor to output association information so that we can adjust the pin
    -- text's bounding box.
    offset = 25
  in
    [ Fact "text" labelId (Just $ stringPrefix ++ show stringId)
    , Fact "bounding_box_top" labelId (Just $ show $ y point + offset - 1)
    , Fact "bounding_box_left" labelId (Just $ show $ x point + offset - 1)
    , Fact "bounding_box_bottom" labelId (Just $ show $ y point + offset + 1)
    , Fact "bounding_box_right" labelId (Just $ show $ x point + offset + 1)
    ]

getRectFacts :: ConversionState -> CanvasItem -> Coords -> Coords -> ConversionState
getRectFacts (id, strings, metadata, facts) canvasItem topLeft bottomRight =
    (id + 2, strings ++ newStrings, newMetadata : metadata, facts ++ newFacts)
  where
    idStr = "id" ++ show id
    id2Str = "id" ++ show (id + 1)
    stringId = length strings
    newStrings = [Fact (show stringId) (kindName canvasItem) Nothing]
    newMetadata =
      TMD.Metadata 
        (gitRef canvasItem)
        (gitUrl canvasItem)
        (manifestPath canvasItem)
        (kindName canvasItem)
    newFacts =
      [ Fact "eltype" idStr (Just "box")
      , Fact "rect" idStr Nothing
      , Fact "bounding_box_top" idStr (Just $ show $ y topLeft)
      , Fact "bounding_box_left" idStr (Just $ show $ x topLeft)
      , Fact "bounding_box_bottom" idStr (Just $ show $ y bottomRight)
      , Fact "bounding_box_right" idStr (Just $ show $ x bottomRight)
      , Fact "text" id2Str (Just $ stringPrefix ++ show stringId)
      , Fact "bounding_box_top" id2Str (Just $ show $ y topLeft + 1)
      , Fact "bounding_box_left" id2Str (Just $ show $ x topLeft + 1)
      , Fact "bounding_box_bottom" id2Str (Just $ show $ y bottomRight - 1)
      , Fact "bounding_box_right" id2Str (Just $ show $ x bottomRight - 1)
      ]

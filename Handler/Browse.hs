module Handler.Browse where

import Import

getBrowseR :: Handler Html
getBrowseR = redirect $ BrowsePageR 1

module Handler.PasteDelete where

import Import

getPasteDeleteR :: Text -> Handler Html
getPasteDeleteR text = do
  _ <- runDB $ getBy404 $ UniquePasteKey text
  runDB $ deleteBy $ UniquePasteKey text
  defaultLayout [whamlet|<p>Paste deleted!|]

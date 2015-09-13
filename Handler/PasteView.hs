module Handler.PasteView where

import Import

getPasteViewR :: PasteId -> Handler Html
getPasteViewR pasteId = do
  paste <- runDB (get pasteId) >>=
           \case
              Just x -> return x
              Nothing -> notFound
  defaultLayout $
    $(widgetFile "paste-view")

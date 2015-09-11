module Handler.PasteView where

import Import

getPasteViewR :: PasteId -> Handler Html
getPasteViewR pasteId = do
  paste <- runDB (get pasteId) >>=
           \case
              Just x -> return x
              Nothing -> notFound
  defaultLayout $
    [whamlet|
      <a href=@{PasteEditR pasteId}>Edit this paste</a>
      <div .container>
        #{pasteHtml paste}
    |]

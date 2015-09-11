module Handler.PasteRaw where

import Import
import Yesod.Markdown

getPasteRawR :: PasteId -> Handler TypedContent
getPasteRawR pasteId =
  runDB (get pasteId) >>=
  \case
    Nothing -> notFound
    Just paste ->
      respond "text/plain" (unMarkdown (pasteMarkdown paste))

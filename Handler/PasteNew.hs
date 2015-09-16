module Handler.PasteNew where

import Import
import Model.Paste
import View.Form

getPasteNewR :: Handler Html
getPasteNewR = do
  (widget, enctype) <- generateFormPost (pasteForm Nothing)
  defaultLayout $
    mkFormView PasteNewR widget enctype

postPasteNewR :: Handler Html
postPasteNewR = do
  ((result, widget), enctype) <- runFormPost (pasteForm Nothing)
  case result of
    FormMissing ->
      defaultLayout
        [whamlet|
          <p .error>Form is missing
          ^{mkFormView PasteNewR widget enctype}
        |]
    FormFailure errors -> do
      defaultLayout $
        [whamlet|
          <ul>
            $forall err <- errors
              <li>#{err}
          ^{mkFormView PasteNewR widget enctype}
        |]
    FormSuccess paste -> do
      pasteId <- runDB (insert paste)
      defaultLayout $ do
        let delKey = pasteDeleteKey paste
        [whamlet|
          <p>
            Delete URL (only shows up once):
            <code>@{PasteDeleteR delKey}
        |]
        $(widgetFile "paste-view")

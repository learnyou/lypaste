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
      pasteID <- runDB (insert paste)
      defaultLayout $ do
        let delKey = pasteDeleteKey paste
        [whamlet|
          <ul>
            <li>
              If you want to delete this paste, visit
              <a href=@{PasteDeleteR delKey}>&lt;@{PasteDeleteR delKey}&gt;</a>.
            <li>
              If you want to edit it, please visit
              <a href=@{PasteEditR pasteID}>&lt;@{PasteEditR pasteID}&gt;</a>.
          <div .container>
            #{pasteHtml paste}
        |]

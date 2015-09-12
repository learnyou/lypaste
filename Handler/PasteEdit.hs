module Handler.PasteEdit where

import           Import
import           Model.Paste

getPasteEditR :: PasteId -> Handler Html
getPasteEditR pasteId = do
  (widget, enctype) <- generateFormPost (mkFormFor pasteId)
  defaultLayout $
    [whamlet|
      <form role=form method=post target=@{PasteEditR pasteId} enctype=#{enctype}>
        ^{widget}
    |]

postPasteEditR :: PasteId -> Handler Html
postPasteEditR pasteId = do
  ((result, widget), enctype) <- runFormPost (mkFormFor pasteId)
  case result of
    FormMissing ->
      defaultLayout $
        [whamlet|
          <p .error>Form is missing
          <form role=form method=post target=@{PasteEditR pasteId} enctype=#{enctype}>
            ^{widget}
        |]
    FormFailure errors -> do
      defaultLayout $
        [whamlet|
          <ul>
            $forall err <- errors
              <li>#{err}
          <form role=form method=post target=@{PasteEditR pasteId} enctype=#{enctype}>
            ^{widget}
        |]
    FormSuccess paste -> do
      runDB $ update pasteId
        [PasteMarkdown =. pasteMarkdown paste
        ,PasteHtml =. pasteHtml paste
        ]
      redirect $ PasteViewR pasteId

mkFormFor :: PasteId -> Html -> MForm Handler (FormResult Paste, Widget)
mkFormFor pasteId ht = do
  paste <- lift $ runDB (get404 pasteId)
  pasteForm (Just (pasteMarkdown paste)) ht

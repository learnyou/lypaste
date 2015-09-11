module Handler.Home where

import Import
import Model.Paste

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getHomeR :: Handler Html
getHomeR = do
  (widget, enctype) <- generateFormPost (pasteForm Nothing)
  defaultLayout $ do
    [whamlet|
      <form role=form method=post target=@{HomeR} enctype=#{enctype}>
        ^{widget}
    |]

postHomeR :: Handler Html
postHomeR = do
  ((result, widget), enctype) <- runFormPost (pasteForm Nothing)
  case result of
    FormMissing ->
      defaultLayout $
        [whamlet|
          <form role=form method=post target=@{HomeR} enctype=#{enctype}>
            ^{widget}
        |]
    FormFailure errors -> do
      defaultLayout $
        [whamlet|
          <form role=form method=post target=@{HomeR} enctype=#{enctype}>
            ^{widget}
        |]
    FormSuccess paste -> do
      pasteID <- runDB (insert paste)
      defaultLayout $ do
        let delKey = pasteDeleteKey paste
        [whamlet|
          <p>The following URLs only show up once, so please save them
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

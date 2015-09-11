module Handler.Home where

import qualified Data.Text as T
import Data.Time
import Import
import Text.Pandoc
import Yesod.Form.Bootstrap3
import Yesod.Markdown

lypasteReaderOptions :: ReaderOptions
lypasteReaderOptions =
  yesodDefaultReaderOptions { readerExtensions = pandocExtensions }

lypasteWriterOptions :: WriterOptions
lypasteWriterOptions =
  yesodDefaultWriterOptions
    { writerHTMLMathMethod = MathJax
                               "http://static.learnyou.org/mathjax/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
    }

pasteForm :: Maybe Text -> Html ->  MForm Handler (FormResult Paste, Widget)
pasteForm existingText extra = do
  (markdownRes, markdownView) <- mreq markdownField (bfs ("Markdown Input" :: Text))
                                   (fmap Markdown existingText)
  (_, submitButtonView) <- mbootstrapSubmit ("Paste" :: BootstrapSubmit Text)
  let htmlRes =
        case parseMarkdown lypasteReaderOptions <$> markdownRes of
          FormSuccess result ->
            case result of
              Left err -> FormFailure [T.pack (show err)]
              Right pd -> FormSuccess $ writePandoc lypasteWriterOptions pd
          -- Stupid GHC
          FormFailure f -> FormFailure f
          FormMissing -> FormMissing
      widget = $(widgetFile "paste-form")
  time <- liftIO getCurrentTime
  return (Paste <$> markdownRes <*> htmlRes <*> pure time, widget)

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
      redirect $ PasteViewR pasteID

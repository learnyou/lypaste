module Model.Paste where

import           Control.Lens
import           Crypto.Random
import qualified Data.ByteString.Base16 as BH
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import           Data.Time
import           Import
import           Text.Pandoc
import           Yesod.Form.Bootstrap3
import           Yesod.Markdown

instance Monad FormResult where
  return = pure
  FormMissing >>= _ = FormMissing
  FormFailure x >>= _ = FormFailure x
  FormSuccess x >>= f = f x

pasteForm :: Maybe Markdown -> Html ->  MForm Handler (FormResult Paste, Widget)
pasteForm existingText extra = do
  (markdownRes, markdownView) <- mreq markdownField (bfs ("Markdown Input" :: Text)) existingText
  (_, submitButtonView) <- mbootstrapSubmit ("Paste" :: BootstrapSubmit Text)
  let widget = do
        toWidget
          [julius|
            $('textarea').attr('rows', 20);
          |]
        toWidget
          [lucius|
            textarea {
              font-family: monospace;
              height: 450px;
            }
          |]
        [whamlet|
          #{extra}
          <div .form-group .paste-input>
            ^{fvInput markdownView}
          <div .form-group>
            ^{fvInput submitButtonView}
        |]
      html = markdownRes >>= mkHtml
  time <- liftIO getCurrentTime
  delKey <- liftIO mkDeleteKey
  return (Paste <$> markdownRes <*> html <*> pure time <*> pure delKey, widget)

errorify :: Either [Text] x -> FormResult x
errorify = \case
  Left x  -> FormFailure x
  Right x -> FormSuccess x

mkHtml :: Markdown -> FormResult Html
mkHtml =
  errorify .
  over _Right (writePandoc lypasteWriterOptions) .
  over _Left (pure . T.pack . show) .
  parseMarkdown lypasteReaderOptions

mkDeleteKey :: IO Text
mkDeleteKey = do
  entropyPool <- createEntropyPool
  let rng :: SystemRNG
      rng = cprgCreate entropyPool
      (bs, _) = cprgGenerate 20 rng
  return (T.decodeUtf8 (BH.encode bs))

lypasteReaderOptions :: ReaderOptions
lypasteReaderOptions =
  yesodDefaultReaderOptions { readerExtensions = pandocExtensions }

lypasteWriterOptions :: WriterOptions
lypasteWriterOptions =
  yesodDefaultWriterOptions
    { writerHTMLMathMethod = MathJax
                               "http://static.learnyou.org/mathjax/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
    }

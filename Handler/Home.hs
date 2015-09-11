module Handler.Home where

import qualified Data.Text as T
import Data.Time
import Import
import Yesod.Markdown

pasteForm :: Maybe Text -> Html ->  MForm Handler (FormResult Paste, Widget)
pasteForm existingText potentialErrorMessage =
  do (markdownRes,markdownView) <-
       mreq textareaField "Markdown Input" (fmap Textarea existingText)
     let markdownRes' = Markdown <$> unTextarea <$> markdownRes
         htmlRes =
           case fmap markdownToHtml markdownRes' of
             FormSuccess result ->
               case result of
                 Left err -> FormFailure [T.pack (show err)]
                 Right x -> FormSuccess x
             -- Stupid GHC
             FormFailure f -> FormFailure f
             FormMissing -> FormMissing
         widget =
           [whamlet|
             #{potentialErrorMessage}
             ^{fvInput markdownView}
           |]
     time <- liftIO getCurrentTime
     return (Paste <$> markdownRes' <*> htmlRes <*> pure time,widget)

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getHomeR :: Handler Html
getHomeR = fail "No"

postHomeR :: Handler Html
postHomeR = fail "No"

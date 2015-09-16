module Handler.BrowsePage where

import           Data.Time.Format.Human
import           Database.Esqueleto
import           Import

getBrowsePageR :: Int -> Handler Html
getBrowsePageR x
  | x <= 0 = notFound
  | otherwise = do
      -- List pastes in descending order
      pastes <- runDB $ select $ from $ \paste -> do
                  orderBy [desc (paste ^. PasteId)]
                  return paste


      -- 10 pastes per page
      --
      -- Drop 10 * (x - 1) (so 0 for 1, 10 for 2, 20 for 3, etc)
      --
      -- Then take 10
      --
      let num = 25
          pastes' = take num $ drop (num * (x - 1)) $ pastes
          maxPage = ceiling $ fromIntegral (length pastes) / num
      if null pastes'
        then notFound
        else return ()
      pasteTimes <- liftIO $ mapM (humanReadableTime . pasteTime . entityVal) pastes'

      -- Then just list the paste with its time
      defaultLayout $ do
        [whamlet|
          <div .container .jumbotron>
            <ul>
              $forall (p,t) <- zip pastes' pasteTimes
                <li>
                  <a href=@{PasteViewR (entityKey p)}>Paste ##{fromSqlKey $ entityKey p} pasted #{t}
          <div .navbar>
            <div .container>
              $if x > 1
                <ul .nav .navbar-nav .navbar-left>
                  <li>
                    <a href=@{BrowsePageR (x - 1)}>
                      <span .glyphicon .glyphicon-arrow-left>
                      Previous Page
              $else

              $if x < maxPage
                <ul .nav .navbar-nav .navbar-right>
                  <li>
                    <a href=@{BrowsePageR (x + 1)}>
                      Next Page
                      <span .glyphicon .glyphicon-arrow-right>
              $else
              
        |]

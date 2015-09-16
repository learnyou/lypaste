module Handler.BrowsePage where

import           Database.Esqueleto
import           Import

getBrowsePageR :: Int -> Handler Html
getBrowsePageR x
  | x <= 0 = notFound
  | x > 0 = do
      error "Not yet implemented"
      -- -- List pastes in descending order
      -- pastes <- runDB $ select $ from $ \paste -> do
      --             orderBy [desc (entityVal paste ^. PasteId)]
      --             return (entityKey paste, paste)

      -- -- 10 pastes per page
      -- --
      -- -- Drop 10 * (x - 1) (so 0 for 1, 10 for 2, 20 for 3, etc)
      -- --
      -- -- Then take 10
      -- --
      -- let pastes' = take 10 $ drop (10 * (x - 1)) $ pastes

      -- -- Then just list the paste with its time
      -- defaultLayout $ do
      --   [whamlet|
      --     <div .container .jumbotron>
      --       <ul>
      --         $forall (p, _) <- pastes'
      --           <li>
      --             <a href=@{PasteViewR p}>Paste
      --   |]

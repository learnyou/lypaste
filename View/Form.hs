module View.Form where

import Import

mkFormView :: Route App -> Widget -> Enctype -> Widget
mkFormView url widget enctype = 
  [whamlet|
    <form role=form method=post target=@{url} enctype=#{enctype}>
      ^{widget}
  |]

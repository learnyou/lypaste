module View.Form where

import Import

mkFormView :: Route App -> Enctype -> Widget -> Widget
mkFormView url enctype widget = 
  [whamlet|
    <form role=form method=post target=@{url} enctype=#{enctype}>
      ^{widget}
  |]

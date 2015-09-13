module View.Form where

mkFormView :: url -> enc -> Widget -> Widget
mkFormview url enctype widget = 
  [whamlet|
    <form role=form method=post target=@{url} enctype=#{enctype}>
      ^{widget}
  |]

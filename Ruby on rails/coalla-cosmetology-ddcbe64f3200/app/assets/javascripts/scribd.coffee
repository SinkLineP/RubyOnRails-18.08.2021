SCRIBD_PUBLISHER_ID = 'pub-94534106639467603268531069'

scribd_doc = scribd.Document.getDoc(gon.book_code)

if gon.book_secret_password == undefined
  scribd_doc.addParam('access_key', SCRIBD_PUBLISHER_ID)
else
  scribd_doc.addParam('secret_password', gon.book_secret_password)

scribd_doc.addParam('jsapi_version', 2)
scribd_doc.addParam('height', 600)
scribd_doc.write('embedded_doc')
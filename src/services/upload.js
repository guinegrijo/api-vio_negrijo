const multer = require("multer")
const storage = multer.memoryStorage() //salvar em memória ram
const upload = multer({storage})

module.exports = upload
require './app'
require './middlewares/chat_backend'

use TurboChat::ChatBackend

run TurboChat::App

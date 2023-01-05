lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rikkicom/client'

LOGIN = '***'
PASSWORD = '***'

CALL_TO = '+380631010121'
CODE = '1234w'
LANG = 'uk'

begin
    client = Rikkicom::Call2FA::Client.new(LOGIN, PASSWORD)

    info = client.callWithCode(CALL_TO, CODE, LANG)
    puts info
rescue ArgumentError => e
    puts "Something went wrong:" 
    puts e.message
rescue RuntimeError => e
    puts "Something went wrong:" 
    puts e.message
end
